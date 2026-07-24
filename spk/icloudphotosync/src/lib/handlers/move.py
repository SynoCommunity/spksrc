"""
Move Handler — start/stop/status for target_dir move operations.

Actions:
  start   — Launch move_runner in background
  stop    — Signal move_runner to stop
  status  — Return MoveProgress dict
"""
import base64
import os
import subprocess
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.realpath(__file__))))

import config_manager
from move_engine import MoveProgress
from sync_engine import SyncProgress


def handle(params):
    action = params.getvalue("action", "")
    if action == "start":
        return _start(params)
    if action == "stop":
        return _stop(params)
    if action == "status":
        return _status(params)
    return {"success": False, "error": {"code": 101, "message": "Unknown action"}}


def _runner_alive(account_id):
    try:
        for pid in os.listdir("/proc"):
            if not pid.isdigit():
                continue
            try:
                with open("/proc/%s/cmdline" % pid, "rb") as f:
                    cmdline = f.read().decode("utf-8", errors="ignore")
            except (OSError, IOError):
                continue
            if "move_runner.py" in cmdline and account_id in cmdline:
                return True
        return False
    except Exception:
        return False


def _start(params):
    account_id = params.getvalue("account_id", "").strip()
    old_dir = params.getvalue("old_dir", "").strip()
    new_dir = params.getvalue("new_dir", "").strip()
    if not account_id or not old_dir or not new_dir:
        return {"success": False, "error": {"code": 301, "message": "account_id/old_dir/new_dir required"}}

    sp = SyncProgress.load(account_id)
    if sp.status in ("syncing", "starting"):
        return {"success": False, "error": {"code": 303, "message": "Sync l\u00e4uft — bitte erst anhalten."}}

    mp = MoveProgress.load(account_id)
    if mp.status in ("starting", "moving") and _runner_alive(account_id):
        return {"success": False, "error": {"code": 304, "message": "Verschiebung l\u00e4uft bereits."}}

    progress = MoveProgress(account_id)
    progress.status = "starting"
    progress.old_dir = old_dir
    progress.new_dir = new_dir
    progress.save()

    pkg_target = os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__))))
    runner = os.path.join(pkg_target, "bin", "move_runner.py")
    log_file = os.path.join(config_manager.PKG_VAR, "logs", "move.log")

    old_b64 = base64.b64encode(old_dir.encode("utf-8")).decode("ascii")
    new_b64 = base64.b64encode(new_dir.encode("utf-8")).decode("ascii")

    try:
        with open(log_file, "a") as lf:
            subprocess.Popen(
                [sys.executable, runner, account_id, old_b64, new_b64],
                stdout=lf, stderr=lf,
                stdin=subprocess.DEVNULL,
                start_new_session=True,
            )
    except Exception as e:
        progress.status = "error"
        progress.error = "Failed to start move: %s" % e
        progress.save()
        return {"success": False, "error": {"code": 500, "message": str(e)}}

    return {"success": True, "data": {"message": "Move started"}}


def _stop(params):
    account_id = params.getvalue("account_id", "").strip()
    if not account_id:
        return {"success": False, "error": {"code": 301, "message": "account_id required"}}
    stop_file = os.path.join(config_manager.get_account_dir(account_id), ".stop_move")
    try:
        with open(stop_file, "w") as f:
            f.write("stop")
    except Exception:
        pass
    return {"success": True, "data": {"message": "Stop requested"}}


def _status(params):
    account_id = params.getvalue("account_id", "").strip()
    if not account_id:
        return {"success": False, "error": {"code": 301, "message": "account_id required"}}

    progress = MoveProgress.load(account_id)

    # Self-heal stale state.
    if progress.status in ("starting", "moving") and not _runner_alive(account_id):
        import time as _t
        progress.status = "stopped"
        if not progress.finished_at:
            progress.finished_at = int(_t.time())
        progress.error = progress.error or "Move-Prozess nicht aktiv (abgestürzt oder beendet)."
        progress.save()

    return {"success": True, "data": progress.to_dict()}
