#!/usr/bin/env python3
"""
Scheduler daemon — long-running process that triggers periodic syncs.

Replaces the root-only /etc/crontab approach, which does not work for
community packages (postinst/start-stop-status do not run as root on DSM 7).

Runs as the package user (sc-icloudphotosync) under service-setup.
"""
import logging
import os
import signal
import sys
import threading
import time
import traceback


def _record_startup_failure(exc):
    # start-stop-status passes ICLOUD_STARTUP_ERR so a crash before the
    # regular log handlers are wired up still lands somewhere visible.
    # Fallback to a conventional path so this is useful even when invoked
    # outside the DSM lifecycle (manual debugging).
    path = os.environ.get("ICLOUD_STARTUP_ERR") or \
        "/var/packages/iCloudPhotoSync/var/logs/startup-error.log"
    try:
        os.makedirs(os.path.dirname(path), exist_ok=True)
    except OSError:
        pass
    try:
        with open(path, "a") as f:
            f.write("==== %s scheduler.py import/startup failure ====\n" %
                    time.strftime("%Y-%m-%d %H:%M:%S"))
            f.write("python: %s\n" % sys.version.replace("\n", " "))
            f.write("platform: %s\n" % sys.platform)
            f.write("cwd: %s\n" % os.getcwd())
            f.write("sys.path: %s\n" % sys.path)
            traceback.print_exc(file=f)
            f.write("\n")
    except OSError:
        # We can't write the diagnostic; re-raise so DSM at least gets the
        # stderr via start-stop-status's redirect to scheduler.log.
        raise exc


PKG_TARGET = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
LIB_DIR = os.path.join(PKG_TARGET, "lib")
VENDOR_DIR = os.path.join(LIB_DIR, "vendor")
sys.path.insert(0, LIB_DIR)
if os.path.isdir(VENDOR_DIR):
    sys.path.insert(0, VENDOR_DIR)

try:
    import config_manager
    import notifier
    import sync_engine
except Exception as _e:
    _record_startup_failure(_e)
    raise

# Apple's iCloud trusted-session cookie is valid ~60 days. Warn at <14 days
# remaining so the user has time to re-authenticate before the nightly sync
# starts failing silently.
SESSION_LIFETIME_DAYS = 60
EXPIRY_WARN_DAYS = 14

LOG_DIR = os.path.join(config_manager.PKG_VAR, "logs")
os.makedirs(LOG_DIR, exist_ok=True)

# Dedicated scheduler.log for scheduling decisions, and sync.log for the
# actual sync runs (same file the manual sync_runner writes to). Without
# this split, in-process sync threads would dump into scheduler.log and the
# UI's "view sync log" would appear empty during scheduled runs.
_fmt = logging.Formatter(
    "%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
_log_level_name = config_manager.load_config().get("log_level", "INFO").upper()
_log_level = getattr(logging, _log_level_name, logging.INFO)

_sync_handler = logging.FileHandler(os.path.join(LOG_DIR, "sync.log"))
_sync_handler.setFormatter(_fmt)
logging.getLogger().addHandler(_sync_handler)
logging.getLogger().setLevel(_log_level)

_sched_handler = logging.FileHandler(os.path.join(LOG_DIR, "scheduler.log"))
_sched_handler.setFormatter(_fmt)
LOGGER = logging.getLogger("scheduler")
LOGGER.addHandler(_sched_handler)
LOGGER.propagate = False  # keep scheduler chatter out of sync.log

_stop_event = threading.Event()
_running_lock = threading.Lock()
_running = {}  # account_id -> Thread


def _stop(signum, frame):
    LOGGER.info("Received signal %s, stopping scheduler", signum)
    _stop_event.set()


def _interval_seconds(account_id):
    # Per-account: UI saves sync_interval_hours into each account's
    # sync_config.json, not the global config.json. Reading the global
    # file would always return the default 6h.
    cfg = config_manager.get_sync_config(account_id)
    hours = cfg.get("sync_interval_hours", 6)
    try:
        hours = int(hours)
    except (TypeError, ValueError):
        hours = 6
    if hours < 1:
        hours = 1
    return hours * 3600


def _last_run_path(account_id):
    return os.path.join(config_manager.get_account_dir(account_id), ".last_scheduled_run")


def _first_sync_flag(account_id):
    return os.path.join(config_manager.get_account_dir(account_id), ".first_sync_done")


def _first_sync_done(account_id):
    return os.path.isfile(_first_sync_flag(account_id))


def _due(account_id, interval):
    # Hard gate: until the user has kicked off the first sync manually, the
    # scheduler never auto-runs — even across DSM reboots. This gives them
    # time to finish configuring albums/folders before anything downloads.
    if not _first_sync_done(account_id):
        return False
    path = _last_run_path(account_id)
    try:
        return (time.time() - os.path.getmtime(path)) >= interval
    except OSError:
        # Flag is set but timestamp is missing (e.g. file wiped manually).
        # Treat as due so the scheduler resumes instead of stalling forever.
        return True


def _mark_ran(account_id):
    path = _last_run_path(account_id)
    try:
        with open(path, "w") as f:
            f.write(str(int(time.time())))
    except OSError:
        pass


def _check_auth_notifications(acc):
    """Push DSM notifications about auth state. Throttled per kind."""
    account_id = acc["id"]
    apple_id = acc.get("apple_id", "")
    status = acc.get("status")

    if status == "re_auth_needed":
        notifier.notify(
            account_id, "reauth",
            "reauth_title", "reauth_msg",
            args=[apple_id],
            throttle_hours=24,
        )
        return

    if status != "authenticated":
        return

    auth_at = acc.get("authenticated_at", 0)
    if not auth_at:
        return
    days_old = (time.time() - auth_at) / 86400.0
    days_left = SESSION_LIFETIME_DAYS - days_old
    if days_left <= EXPIRY_WARN_DAYS:
        notifier.notify(
            account_id, "expiring",
            "expiring_title", "expiring_msg",
            args=[apple_id, max(int(days_left), 0)],
            throttle_hours=24 * 7,
        )


def _run_account(account_id):
    try:
        progress = sync_engine.run_sync(account_id)
    except Exception:
        LOGGER.exception("Sync crashed for account %s", account_id)
        progress = None
    finally:
        # Only mark ran if we actually ran. If another process held the
        # lock, run_sync returns status="skipped" — pushing out the next
        # due time would skip 6h for a sync that never happened.
        if progress is None or getattr(progress, "status", None) != "skipped":
            _mark_ran(account_id)
        with _running_lock:
            _running.pop(account_id, None)


def _tick():
    for acc in config_manager.get_accounts():
        try:
            _check_auth_notifications(acc)
        except Exception:
            LOGGER.exception("Notification check failed for %s", acc.get("id"))

        if acc.get("status") != "authenticated":
            continue
        account_id = acc["id"]
        with _running_lock:
            if account_id in _running:
                continue
        if not _due(account_id, _interval_seconds(account_id)):
            continue
        with _running_lock:
            if account_id in _running:
                continue
            t = threading.Thread(
                target=_run_account, args=(account_id,),
                name=f"sync-{account_id}", daemon=True,
            )
            _running[account_id] = t
            t.start()
        LOGGER.info("Dispatched sync for account %s", account_id)


def main():
    signal.signal(signal.SIGTERM, _stop)
    signal.signal(signal.SIGINT, _stop)
    LOGGER.info("Scheduler started (pid=%d)", os.getpid())

    # Wake every 60s so interval/config changes take effect quickly.
    # Event.wait returns immediately on _stop, so SIGTERM no longer eats
    # up to a second of stop latency (DSM gives the package only a few
    # seconds before SIGKILL during pkg stop).
    while not _stop_event.is_set():
        try:
            _tick()
        except Exception:
            LOGGER.exception("Tick failed")
        _stop_event.wait(timeout=60)

    # Request stop on all running account syncs so they terminate quickly
    # instead of being killed mid-write by SIGKILL.
    with _running_lock:
        running_ids = list(_running.keys())
        threads = list(_running.values())
    for aid in running_ids:
        try:
            sync_engine.request_stop(aid)
        except Exception:
            LOGGER.exception("request_stop failed for %s", aid)
    for t in threads:
        t.join(timeout=3)

    LOGGER.info("Scheduler stopped")


if __name__ == "__main__":
    main()
