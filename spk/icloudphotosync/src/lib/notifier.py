"""
DSM Notification helper for the iCloud Photo Sync 3rd-party app.

Uses the documented DSM SPA mechanism:
  - The app registers `texts: "texts"` and `preloadTexts: [...]` in ui/config
    so DSM loads ui/texts/<locale>/strings into the namespace
    `SYNO.SDS.iCloudPhotoSync.Instance`.
  - We push notifications via `synodsmnotify -c <className> @recipient
    <title_key> <msg_key> [arg0 arg1 ...]`. Title/msg keys use the form
    `<className>:<section>:<key>`. Positional args after the msg key fill
    `{0}`, `{1}` placeholders inside the strings file.

Notifications are throttled per (account_id, kind) via marker files so the
scheduler tick doesn't spam the user every 60 seconds. Errors are always
swallowed -- a failed notification must never break the scheduler.
"""
import logging
import os
import subprocess
import time

import config_manager

LOGGER = logging.getLogger("notifier")

NOTIFY_BIN = "/usr/syno/bin/synodsmnotify"
APP_CLASS = "SYNO.SDS.iCloudPhotoSync.Instance"


def _marker_path(account_id, kind):
    return os.path.join(config_manager.get_account_dir(account_id), ".notif_" + kind)


def _i18n(key):
    return APP_CLASS + ":notification:" + key


def notify(account_id, kind, title_key, msg_key, args=None, throttle_hours=24):
    """Send a DSM notification using the app's own i18n strings.

    `kind` is a short identifier used only for the throttle marker filename
    (e.g. "reauth", "expiring"). `title_key` / `msg_key` are the keys inside
    the `[notification]` section of ui/texts/<locale>/strings. `args` is an
    optional list of positional substitutions for {0}, {1}, ... in the msg.
    """
    marker = _marker_path(account_id, kind)
    try:
        if os.path.isfile(marker):
            age = time.time() - os.path.getmtime(marker)
            if age < throttle_hours * 3600:
                return False
    except OSError:
        pass

    if not os.path.exists(NOTIFY_BIN):
        LOGGER.warning("synodsmnotify not found at %s; skipping notification", NOTIFY_BIN)
        return False

    cmd = [
        NOTIFY_BIN, "-c", APP_CLASS,
        "@administrators",
        _i18n(title_key), _i18n(msg_key),
    ]
    if args:
        cmd.extend(str(a) for a in args)

    try:
        subprocess.run(cmd, timeout=10, check=False)
        with open(marker, "w") as f:
            f.write(str(int(time.time())))
        LOGGER.info("Sent notification (%s) for account %s", kind, account_id)
        return True
    except Exception:
        LOGGER.exception("Failed to send notification (%s) for %s", kind, account_id)
        return False


def clear_marker(account_id, kind):
    """Remove a throttle marker so the next notify() will fire again."""
    try:
        os.remove(_marker_path(account_id, kind))
    except OSError:
        pass


def clear_all_markers(account_id):
    """Clear every notification marker for an account (e.g. after re-auth)."""
    acc_dir = config_manager.get_account_dir(account_id)
    try:
        for name in os.listdir(acc_dir):
            if name.startswith(".notif_"):
                try:
                    os.remove(os.path.join(acc_dir, name))
                except OSError:
                    pass
    except OSError:
        pass
