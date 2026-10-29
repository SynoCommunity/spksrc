"""
Auth Handler — Apple ID login and 2FA verification.

Actions:
  login       — Start login with apple_id + password, returns 2FA status
  verify_2fa  — Submit 6-digit 2FA code
  status      — Check if session for account_id is still authenticated
"""
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.realpath(__file__))))

import fcntl
import json
import time

import config_manager
import icloud_client
import notifier

_MAX_ATTEMPTS = 5
_WINDOW_SECONDS = 60


def _rate_limit(key):
    """Returns True if the request should be blocked.

    Allows _MAX_ATTEMPTS per key within _WINDOW_SECONDS. Uses fcntl.flock
    for inter-process safety (each CGI request is a separate process).
    """
    now = time.time()
    state_file = os.path.join(config_manager.PKG_VAR, ".rate_limit")
    lock_file = state_file + ".lock"

    try:
        lock_fd = os.open(lock_file, os.O_WRONLY | os.O_CREAT, 0o600)
    except OSError:
        return False

    try:
        fcntl.flock(lock_fd, fcntl.LOCK_EX)

        attempts = {}
        try:
            with open(state_file, "r") as f:
                attempts = json.load(f)
        except Exception:
            pass

        for k in list(attempts):
            pruned = [t for t in attempts[k] if now - t < _WINDOW_SECONDS]
            if pruned:
                attempts[k] = pruned
            else:
                del attempts[k]

        entries = attempts.get(key, [])
        blocked = len(entries) >= _MAX_ATTEMPTS

        if not blocked:
            entries.append(now)
            attempts[key] = entries

        try:
            tmp = state_file + ".tmp"
            fd = os.open(tmp, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600)
            with os.fdopen(fd, "w") as f:
                json.dump(attempts, f)
                f.flush()
                os.fsync(f.fileno())
            os.replace(tmp, state_file)
        except Exception:
            pass

        return blocked
    finally:
        fcntl.flock(lock_fd, fcntl.LOCK_UN)
        os.close(lock_fd)


def handle(params):
    action = params.getvalue("action", "")

    if action == "login":
        return _login(params)
    if action == "verify_2fa":
        return _verify_2fa(params)
    if action == "send_sms":
        return _send_sms(params)
    if action == "status":
        return _auth_status(params)

    return {"success": False, "error": {"code": 101, "message": "Unknown action"}}


def _login(params):
    apple_id = params.getvalue("apple_id", "").strip()
    password = params.getvalue("password", "").strip()

    if not apple_id or not password:
        return {
            "success": False,
            "error": {"code": 201, "message": "apple_id and password required"}
        }

    if _rate_limit("login:" + apple_id.lower()):
        return {
            "success": False,
            "error": {"code": 429, "message": "Too many login attempts, please wait a minute"}
        }

    # Find existing account by apple_id; only create after credentials validate
    account = None
    for acc in config_manager.get_accounts():
        if acc["apple_id"] == apple_id:
            account = acc
            break

    created_new = False
    if not account:
        account = config_manager.add_account(apple_id)
        created_new = True

    # Clear any cached client so we get a fresh one with the password
    icloud_client.remove_client(account["id"])

    # Attempt login
    client = icloud_client.get_client(account["id"], apple_id, password)
    result = client.login()

    if not result["success"]:
        if created_new:
            icloud_client.remove_client(account["id"])
            config_manager.remove_account(account["id"])
        return {
            "success": False,
            "error": {"code": 202, "message": result.get("error", "Login failed")}
        }

    if result.get("requires_2fa"):
        config_manager.update_account(account["id"], {"status": "pending_2fa"})
        # Store password temporarily so SMS re-login works in a later CGI request
        config_manager.save_pending_password(account["id"], password)
        data = {
            "account_id": account["id"],
            "requires_2fa": True,
            "message": result.get("message", "2FA required"),
        }
        return {"success": True, "data": data}

    # Login succeeded without 2FA
    config_manager.update_account(account["id"], {
        "status": "authenticated",
        "authenticated_at": int(time.time()),
    })
    config_manager.clear_pending_password(account["id"])
    notifier.clear_all_markers(account["id"])
    return {
        "success": True,
        "data": {
            "account_id": account["id"],
            "requires_2fa": False,
            "message": "Login successful"
        }
    }


def _send_sms(params):
    account_id = params.getvalue("account_id", "").strip()

    if not account_id:
        return {
            "success": False,
            "error": {"code": 203, "message": "account_id required"}
        }

    if _rate_limit("sms:" + account_id):
        return {
            "success": False,
            "error": {"code": 429, "message": "Too many SMS requests, please wait a minute"}
        }

    account = config_manager.get_account(account_id)
    if not account:
        return {
            "success": False,
            "error": {"code": 204, "message": "Account not found"}
        }

    # Retrieve stored password — SMS needs a fresh re-login
    password = config_manager.get_pending_password(account_id)
    if not password:
        return {
            "success": False,
            "error": {"code": 207, "message": "Password not available, please login again"}
        }

    client = icloud_client.get_client(account_id, account["apple_id"], password)
    result = client.send_sms_code()

    if not result["success"]:
        return {
            "success": False,
            "error": {"code": 206, "message": result.get("error", "SMS send failed")}
        }

    return {
        "success": True,
        "data": {
            "message": result.get("message", "SMS sent"),
            "phone_id": result.get("phone_id"),
            "phone_number": result.get("phone_number"),
        }
    }


def _verify_2fa(params):
    account_id = params.getvalue("account_id", "").strip()
    code = params.getvalue("code", "").strip()

    if not account_id or not code:
        return {
            "success": False,
            "error": {"code": 203, "message": "account_id and code required"}
        }

    if _rate_limit("2fa:" + account_id):
        return {
            "success": False,
            "error": {"code": 429, "message": "Too many verification attempts, please wait a minute"}
        }

    account = config_manager.get_account(account_id)
    if not account:
        return {
            "success": False,
            "error": {"code": 204, "message": "Account not found"}
        }

    phone_id = params.getvalue("phone_id", "").strip() or None
    password = config_manager.get_pending_password(account_id)
    client = icloud_client.get_client(account_id, account["apple_id"], password)
    result = client.verify_2fa(code, phone_id=phone_id)

    if not result["success"]:
        return {
            "success": False,
            "error": {"code": 205, "message": result.get("error", "2FA failed")}
        }

    config_manager.update_account(account_id, {
        "status": "authenticated",
        "authenticated_at": int(time.time()),
    })
    config_manager.clear_pending_password(account_id)
    notifier.clear_all_markers(account_id)
    return {
        "success": True,
        "data": {
            "account_id": account_id,
            "message": result.get("message", "Verified")
        }
    }


def _auth_status(params):
    account_id = params.getvalue("account_id", "").strip()

    if not account_id:
        return {
            "success": False,
            "error": {"code": 203, "message": "account_id required"}
        }

    account = config_manager.get_account(account_id)
    if not account:
        return {
            "success": False,
            "error": {"code": 204, "message": "Account not found"}
        }

    client = icloud_client.get_client(account_id, account["apple_id"])
    authenticated = client.restore_session()

    if authenticated:
        # Backfill authenticated_at if missing (e.g. account from before
        # we tracked this); don't overwrite a real timestamp with "now".
        updates = {"status": "authenticated"}
        if not account.get("authenticated_at"):
            updates["authenticated_at"] = int(time.time())
        config_manager.update_account(account_id, updates)
    else:
        config_manager.update_account(account_id, {"status": "re_auth_needed"})

    return {
        "success": True,
        "data": {
            "account_id": account_id,
            "authenticated": authenticated,
            "status": account.get("status", "unknown")
        }
    }
