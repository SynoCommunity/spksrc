"""
Sync Handler — start/stop/status for sync operations.

Actions:
  start   — Trigger a sync for an account (runs in background)
  stop    — Request stop of a running sync
  status  — Get current sync progress
"""
import os
import subprocess
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.realpath(__file__))))

import config_manager
import sync_manifest
from sync_engine import SyncProgress, heal_stale_progress, runner_alive


def handle(params):
    action = params.getvalue("action", "")

    if action == "start":
        return _start_sync(params)
    if action == "stop":
        return _stop_sync(params)
    if action == "status":
        return _sync_status(params)

    return {"success": False, "error": {"code": 101, "message": "Unknown action"}}


def _start_sync(params):
    account_id = params.getvalue("account_id", "").strip()
    if not account_id:
        return {"success": False, "error": {"code": 301, "message": "account_id required"}}

    account = config_manager.get_account(account_id)
    if not account:
        return {"success": False, "error": {"code": 302, "message": "Account not found"}}

    if account.get("status") != "authenticated":
        return {"success": False, "error": {"code": 303, "message": "Account not authenticated"}}

    # Check if already syncing. Heal stale state first so a crashed runner
    # doesn't permanently block new starts.
    progress = SyncProgress.load(account_id)
    heal_stale_progress(progress)
    if progress.status in ("syncing", "starting"):
        return {"success": False, "error": {"code": 304, "message": "Sync already running"}}

    # Set initial progress
    progress = SyncProgress(account_id)
    progress.status = "starting"
    progress.save()

    # Launch sync_runner as background process
    pkg_target = os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__))))
    runner = os.path.join(pkg_target, "bin", "sync_runner.py")
    log_file = os.path.join(config_manager.PKG_VAR, "logs", "sync.log")

    try:
        with open(log_file, "a") as lf:
            subprocess.Popen(
                [sys.executable, runner, account_id],
                stdout=lf, stderr=lf,
                stdin=subprocess.DEVNULL,
                start_new_session=True,
            )
    except Exception as e:
        progress.status = "error"
        progress.error = "Failed to start sync: %s" % str(e)
        progress.save()
        return {"success": False, "error": {"code": 500, "message": str(e)}}

    return {"success": True, "data": {"message": "Sync started"}}


def _stop_sync(params):
    account_id = params.getvalue("account_id", "").strip()
    if not account_id:
        return {"success": False, "error": {"code": 301, "message": "account_id required"}}

    # Write a stop signal file that sync_runner checks
    stop_file = os.path.join(config_manager.get_account_dir(account_id), ".stop_sync")
    try:
        with open(stop_file, "w") as f:
            f.write("stop")
    except Exception:
        pass

    return {"success": True, "data": {"message": "Stop requested"}}


def _sync_status(params):
    account_id = params.getvalue("account_id", "").strip()
    if not account_id:
        return {"success": False, "error": {"code": 301, "message": "account_id required"}}

    progress = SyncProgress.load(account_id)

    # Next scheduled sync = mtime of .last_scheduled_run + interval.
    # If no marker yet, the scheduler will pick it up on the next tick.
    try:
        import time as _time
        sync_cfg = config_manager.get_sync_config(account_id)
        hours = sync_cfg.get("sync_interval_hours", 6)
        try:
            hours = int(hours)
        except (TypeError, ValueError):
            hours = 6
        if hours < 1:
            hours = 1
        marker = os.path.join(config_manager.get_account_dir(account_id), ".last_scheduled_run")
        last_mtime = 0
        try:
            last_mtime = int(os.path.getmtime(marker))
        except OSError:
            pass
        next_run = last_mtime + hours * 3600 if last_mtime else int(_time.time())
        _next_scheduled_run = next_run
        _sync_interval_hours = hours
    except Exception:
        _next_scheduled_run = 0
        _sync_interval_hours = 0

    heal_stale_progress(progress)

    data = progress.to_dict()
    data["next_scheduled_run"] = _next_scheduled_run
    data["sync_interval_hours"] = _sync_interval_hours
    try:
        data["manifest"] = sync_manifest.get_stats(account_id)
    except Exception:
        data["manifest"] = {"total_synced": 0, "albums_synced": 0, "last_sync": 0, "total_size": 0}
    return {"success": True, "data": data}
