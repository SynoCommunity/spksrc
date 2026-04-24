"""
Account Handler — manage configured Apple ID accounts.

Actions:
  list    — List all configured accounts
  remove  — Remove an account by account_id
  get     — Get details for a single account
"""
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.realpath(__file__))))

import config_manager
import icloud_client


def handle(params):
    action = params.getvalue("action", "")

    if action == "list":
        return _list_accounts()
    if action == "remove":
        return _remove_account(params)
    if action == "get":
        return _get_account(params)

    return {"success": False, "error": {"code": 101, "message": "Unknown action"}}


def _list_accounts():
    accounts = config_manager.get_accounts()
    safe_accounts = []
    for acc in accounts:
        safe_accounts.append({
            "id": acc.get("id"),
            "apple_id": acc.get("apple_id"),
            "status": acc.get("status", "unknown"),
            "photo_count": acc.get("photo_count", 0),
        })
    return {"success": True, "data": {"accounts": safe_accounts}}


def _get_account(params):
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

    return {
        "success": True,
        "data": {
            "id": account.get("id"),
            "apple_id": account.get("apple_id"),
            "status": account.get("status", "unknown"),
            "photo_count": account.get("photo_count", 0),
        }
    }


def _remove_account(params):
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

    icloud_client.remove_client(account_id)
    config_manager.remove_account(account_id)

    return {
        "success": True,
        "data": {"message": "Account removed", "account_id": account_id}
    }
