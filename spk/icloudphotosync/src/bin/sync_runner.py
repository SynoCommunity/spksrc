#!/usr/bin/env python3
"""
Sync Runner — executed by cron or triggered manually via the sync handler.

Usage: python3 sync_runner.py [account_id]
  If account_id is given, syncs only that account.
  If omitted, syncs all authenticated accounts.
"""
import logging
import os
import re
import sys
import time

# Setup paths
PKG_TARGET = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
LIB_DIR = os.path.join(PKG_TARGET, "lib")
VENDOR_DIR = os.path.join(LIB_DIR, "vendor")
sys.path.insert(0, LIB_DIR)
if os.path.isdir(VENDOR_DIR):
    sys.path.insert(0, VENDOR_DIR)

# Older package versions added a `#iCloudPhotoSync` line to /etc/crontab
# that runs us as root every 6h. Scheduling is now owned by the scheduler
# daemon, so that entry causes duplicate parallel syncs. postinst runs as
# the package user and cannot edit /etc/crontab — but cron fires us as
# root, so we self-heal here and exit without syncing.
if hasattr(os, "geteuid") and os.geteuid() == 0:
    try:
        with open("/etc/crontab", "r") as _f:
            _content = _f.read()
        _cleaned = re.sub(r"(?m)^.*#iCloudPhotoSync.*\n?", "", _content)
        if _cleaned != _content:
            with open("/etc/crontab", "w") as _f:
                _f.write(_cleaned)
    except OSError:
        pass
    sys.exit(0)

import config_manager
import sync_engine

# Setup logging
LOG_DIR = os.path.join(config_manager.PKG_VAR, "logs")
os.makedirs(LOG_DIR, exist_ok=True)
LOG_FILE = os.path.join(LOG_DIR, "sync.log")

# Read log level from config (default: INFO for production)
_log_level_name = config_manager.load_config().get("log_level", "INFO").upper()
_log_level = getattr(logging, _log_level_name, logging.INFO)

logging.basicConfig(
    filename=LOG_FILE,
    level=_log_level,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
LOGGER = logging.getLogger("sync_runner")


def run_account(account_id):
    """Run sync for a single account.

    sync_engine.should_stop already checks the .stop_sync file marker, so
    this wrapper no longer needs to monkey-patch anything. Stale stop
    files from a previous run are cleared by run_sync's clear_stop().
    """
    LOGGER.info("Starting sync for account %s", account_id)
    try:
        progress = sync_engine.run_sync(account_id)
        LOGGER.info(
            "Sync finished for %s: status=%s synced=%d skipped=%d failed=%d",
            account_id, progress.status,
            progress.synced_photos, progress.skipped_photos, progress.failed_photos
        )
        # Arm the scheduler: .first_sync_done is a one-time gate that unlocks
        # auto-sync (persists across restarts). .last_scheduled_run is the
        # timestamp used for interval math.
        if progress.status != "skipped":
            acc_dir = config_manager.get_account_dir(account_id)
            try:
                flag = os.path.join(acc_dir, ".first_sync_done")
                if not os.path.isfile(flag):
                    open(flag, "w").close()
                with open(os.path.join(acc_dir, ".last_scheduled_run"), "w") as _m:
                    _m.write(str(int(time.time())))
            except OSError:
                LOGGER.exception("Failed to write scheduler markers for %s", account_id)
    except Exception:
        LOGGER.exception("Sync crashed for account %s", account_id)


def main():
    if len(sys.argv) > 1:
        # Sync specific account
        account_id = sys.argv[1]
        run_account(account_id)
    else:
        # Sync all authenticated accounts
        accounts = config_manager.get_accounts()
        for acc in accounts:
            if acc.get("status") == "authenticated":
                run_account(acc["id"])


if __name__ == "__main__":
    main()
