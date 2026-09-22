"""
Sync Engine — downloads photos from iCloud to local storage.

Uses the sync manifest (SQLite) for deduplication and the config
for folder structure. Always fetches the live photo list from Apple
(never relies on cached album counts).
"""
import contextlib
import fcntl
import logging
import os
import time
import json
import threading
from concurrent.futures import ThreadPoolExecutor, as_completed
from queue import Queue
import requests

import config_manager
import icloud_client
import sync_manifest
import heic_converter

LOGGER = logging.getLogger("sync_engine")


def _sanitize_path_component(name):
    """Remove path traversal and dangerous characters from a single path component."""
    if not name:
        return "unknown"
    name = name.replace("/", "_").replace("\\", "_")
    name = name.replace("\x00", "").replace("\r", "").replace("\n", "")
    while ".." in name:
        name = name.replace("..", "")
    name = name.strip(". ")
    return name or "unknown"


def _safe_join(base, *parts):
    """Join paths and verify the result stays inside base."""
    result = os.path.join(base, *parts)
    result = os.path.realpath(result)
    base = os.path.realpath(base)
    if not result.startswith(base + os.sep) and result != base:
        raise ValueError("Path traversal detected: %s escapes %s" % (result, base))
    return result


def _makedirs_safe(path, mode=0o755):
    """Create directories without following symlinks in intermediate components."""
    parts = []
    head = path
    while True:
        head, tail = os.path.split(head)
        if not tail:
            break
        parts.append(tail)
        if os.path.isdir(head):
            break
    parts.reverse()
    current = head
    for part in parts:
        current = os.path.join(current, part)
        if os.path.islink(current):
            os.remove(current)
        if not os.path.isdir(current):
            os.mkdir(current, mode)


class _UrlExpiredError(Exception):
    """Raised when an iCloud CDN URL returns 410 Gone (expired)."""
    pass


# Network retry settings
_NET_RETRY_MAX = 5           # max pause/retry cycles per album batch run
_NET_RETRY_INTERVAL = 30     # seconds between connectivity checks
_NET_CONSECUTIVE_FAIL = 30   # consecutive download failures before pausing


def _check_connectivity():
    """Return True if we can reach Apple's CDN (lightweight HEAD request)."""
    try:
        r = requests.head("https://www.apple.com", timeout=10)
        return r.status_code < 500
    except Exception:
        return False


def _is_connection_error(exc):
    """Return True if the exception indicates a real connectivity problem."""
    if isinstance(exc, requests.exceptions.ConnectionError):
        return True
    if isinstance(exc, requests.exceptions.Timeout):
        return True
    if isinstance(exc, (OSError, IOError)):
        return True
    return False


def _wait_for_connectivity(account_id, max_cycles=_NET_RETRY_MAX):
    """Block until network is available or max_cycles exhausted.

    Checks connectivity immediately first — if the network is fine,
    returns True without any delay.
    Returns True if connectivity is available, False if we gave up.
    """
    if _check_connectivity():
        LOGGER.info("Network check: connectivity OK, resuming immediately")
        return True
    for cycle in range(max_cycles):
        LOGGER.info("Network check %d/%d — waiting %ds...",
                    cycle + 1, max_cycles, _NET_RETRY_INTERVAL)
        time.sleep(_NET_RETRY_INTERVAL)
        if should_stop(account_id):
            return False
        if _check_connectivity():
            LOGGER.info("Network restored after %d checks", cycle + 1)
            return True
    LOGGER.warning("Network still down after %d checks, giving up", max_cycles)
    return False

# Map folder structure config values to strftime-like path builders
FOLDER_BUILDERS = {
    "year_month_day": lambda ts: _ts_path(ts, "%Y/%m/%d"),
    "year_month": lambda ts: _ts_path(ts, "%Y/%m"),
    "year": lambda ts: _ts_path(ts, "%Y"),
    "flat": lambda ts: "",
}


def _ts_path(timestamp_ms, fmt):
    """Convert CloudKit assetDate (ms since Unix epoch) to a folder path."""
    if not timestamp_ms:
        return "unknown"
    return time.strftime(fmt, time.localtime(timestamp_ms / 1000.0))


def _build_filename(photo, config):
    """Build the filename for a photo based on config."""
    if config.get("filenames") == "date_based" and photo.created:
        raw_ext = os.path.splitext(photo.filename)[1]
        ext = ("." + _sanitize_path_component(raw_ext)) if raw_ext else ".jpg"
        return time.strftime("%Y-%m-%d_%H%M%S", time.localtime(photo.created / 1000.0)) + ext
    return _sanitize_path_component(photo.filename)


def _resolve_conflict(path, config, synced_this_run=None):
    """Handle file conflicts. Returns final path or None to skip.

    synced_this_run: set of paths downloaded in this sync run.
    If a conflict is with a file we just created (same name, different photo),
    always rename regardless of config to avoid data loss.
    """
    if not os.path.exists(path):
        return path

    conflict = config.get("conflict", "skip")

    # If the existing file was created in this same sync run,
    # always rename to avoid losing a different photo with the same name
    if synced_this_run and path in synced_this_run:
        conflict = "rename"

    if conflict == "overwrite":
        return path
    if conflict == "skip":
        return None
    if conflict == "rename":
        base, ext = os.path.splitext(path)
        i = 1
        while os.path.exists("%s_%d%s" % (base, i, ext)):
            i += 1
        return "%s_%d%s" % (base, i, ext)
    return None


def _download_file(url, dest_path, session=None):
    """Download a file from URL to dest_path.

    Writes to dest_path + ".part" first, then atomically renames on success.
    A partial download therefore can never be mistaken for a complete file
    by the next sync's existence check.
    """
    dest_dir = os.path.dirname(dest_path)
    _makedirs_safe(dest_dir)
    # Ensure directories are world-readable so DSM File Station can see them
    try:
        os.chmod(dest_dir, 0o755)
    except OSError:
        pass
    tmp_path = dest_path + ".part"
    # (connect, read) — a read timeout makes iter_content() give up when
    # the stream goes silent, so a rate-limited/stalled chunk can't pin
    # a worker thread forever and block the whole batch.
    timeout = (15, 30)
    last_err = None
    for attempt in range(3):
        try:
            r = (session or requests).get(url, timeout=timeout, stream=True)
            if r.status_code == 410:
                raise _UrlExpiredError("410 Gone for url: %s" % url)
            r.raise_for_status()
            with open(tmp_path, "wb") as f:
                for chunk in r.iter_content(chunk_size=65536):
                    if chunk:
                        f.write(chunk)
                f.flush()
                try:
                    os.fsync(f.fileno())
                except OSError:
                    pass
            os.chmod(tmp_path, 0o644)
            os.replace(tmp_path, dest_path)
            return True
        except _UrlExpiredError:
            try:
                os.remove(tmp_path)
            except OSError:
                pass
            raise
        except Exception as e:
            last_err = e
            try:
                os.remove(tmp_path)
            except OSError:
                pass
            time.sleep(1 + attempt * 2)
    LOGGER.error("Download failed for %s after retries: %s", dest_path, last_err)
    return False


def _writable(path):
    """Return True if the current user can create files under `path`.

    Creates the directory if missing (best-effort); a failure at any stage
    means the sync cannot proceed against this target.
    """
    try:
        os.makedirs(path, exist_ok=True)
        probe = os.path.join(path, ".icloudphotos_write_test")
        with open(probe, "w") as f:
            f.write("ok")
        os.remove(probe)
        return True
    except OSError as e:
        LOGGER.error("Write test failed for %s: %s", path, e)
        _log_path_diagnostics(path)
        return False


def _get_mount_info(path):
    """Return (mountpoint, fstype, mount_options) for the given path, or Nones."""
    try:
        real = os.path.realpath(path)
        best_mp, best_fs, best_opts = "/", "unknown", ""
        with open("/proc/mounts", "r") as f:
            for line in f:
                parts = line.split()
                if len(parts) < 4:
                    continue
                mp, fs, opts = parts[1], parts[2], parts[3]
                if real == mp or real.startswith(mp.rstrip("/") + "/"):
                    if len(mp) > len(best_mp):
                        best_mp, best_fs, best_opts = mp, fs, opts
        return best_mp, best_fs, best_opts
    except Exception:
        return None, None, None


def _log_path_diagnostics(path):
    """Log detailed permission info so support requests are actionable."""
    import grp
    import pwd
    try:
        uid = os.getuid()
        try:
            uname = pwd.getpwuid(uid).pw_name
        except KeyError:
            uname = str(uid)
        gids = os.getgroups()
        gnames = []
        for g in gids:
            try:
                gnames.append(grp.getgrgid(g).gr_name)
            except KeyError:
                gnames.append(str(g))
        LOGGER.error("  Running as: uid=%s(%s) groups=%s", uid, uname, ",".join(gnames))
    except Exception:
        pass

    # Log filesystem type and mount options
    mp, fs, opts = _get_mount_info(path)
    if mp:
        LOGGER.error("  Filesystem: mountpoint=%s type=%s opts=%s", mp, fs, opts)

    # Walk up the path tree to find where permissions diverge.
    parts = path.rstrip("/")
    while parts and parts != "/":
        try:
            st = os.stat(parts)
            try:
                owner = pwd.getpwuid(st.st_uid).pw_name
            except (KeyError, Exception):
                owner = str(st.st_uid)
            try:
                group = grp.getgrgid(st.st_gid).gr_name
            except (KeyError, Exception):
                group = str(st.st_gid)
            mode = oct(st.st_mode)[-3:]
            r = os.access(parts, os.R_OK)
            w = os.access(parts, os.W_OK)
            x = os.access(parts, os.X_OK)
            LOGGER.error("  %s  owner=%s:%s mode=%s access=r%s/w%s/x%s",
                         parts, owner, group, mode, r, w, x)
        except OSError:
            LOGGER.error("  %s  does not exist", parts)
        parts = os.path.dirname(parts)


def _resolve_target_dir(path, account_id=None):
    """Resolve a DSM FileChooser path to the actual filesystem path.

    FileChooser returns virtual share paths:
      /home/Test     -> <volume>/homes/<user>/Test  (special: "home" share = "homes" dir)
      /photo/iCloud  -> <volume>/photo/iCloud
      /volume1/...   -> already absolute, pass through
    """
    if not path:
        return path
    if path.startswith("/volume"):
        return path

    # /home/... is a per-user virtual share -- maps to <volume>/homes/<user>/...
    if path.startswith("/home/") or path == "/home":
        sub = path[5:].lstrip("/")
        dsm_user = ""
        if account_id:
            acc = config_manager.get_account(account_id) or {}
            dsm_user = acc.get("dsm_user", "")
        if not dsm_user:
            dsm_user = os.environ.get("REMOTE_USER", "") or os.environ.get("HTTP_X_SYNO_USER", "")
        if dsm_user:
            return os.path.join(config_manager.DEFAULT_VOLUME, "homes", dsm_user, sub)
        return "__UNRESOLVED_HOME__:" + path

    # Other shared folders: look up which volume the share lives on
    parts = path.strip("/").split("/", 1)
    share_name = parts[0]
    sub_path = parts[1] if len(parts) > 1 else ""
    try:
        import subprocess
        result = subprocess.run(
            ["/usr/syno/sbin/synoshare", "--get", share_name],
            capture_output=True, text=True, timeout=5
        )
        for line in result.stdout.splitlines():
            if line.strip().startswith("Path"):
                real_share = line.split("[", 1)[-1].rstrip("]").strip()
                if real_share:
                    return os.path.join(real_share, sub_path) if sub_path else real_share
    except Exception:
        pass
    return config_manager.DEFAULT_VOLUME + path


class SyncProgress:
    """Tracks sync progress for status reporting."""

    def __init__(self, account_id):
        self.account_id = account_id
        self.status = "idle"  # idle, syncing, error, complete
        self.current_album = ""
        self.total_photos = 0
        self.synced_photos = 0
        self.skipped_photos = 0
        self.failed_photos = 0
        self.started_at = 0
        self.finished_at = 0
        self.error = ""
        self._last_save_ts = 0.0

    def to_dict(self):
        return {
            "status": self.status,
            "current_album": self.current_album,
            "total_photos": self.total_photos,
            "synced_photos": self.synced_photos,
            "skipped_photos": self.skipped_photos,
            "failed_photos": self.failed_photos,
            "started_at": self.started_at,
            "finished_at": self.finished_at,
            "error": self.error,
        }

    def save(self):
        """Persist progress to a JSON file for status queries.

        Atomic write because the UI polls this file while the sync writes
        it ~once per second; without atomicity the poll occasionally hits
        a half-written file and crashes the status handler.
        """
        path = os.path.join(config_manager.get_account_dir(self.account_id), "sync_progress.json")
        try:
            config_manager.atomic_write_json(path, self.to_dict())
            self._last_save_ts = time.time()
        except Exception:
            LOGGER.exception("SyncProgress.save failed for %s", self.account_id)

    def save_throttled(self, min_interval=1.0):
        """Save only if more than min_interval seconds since last save.
        Use in tight loops (per-photo dedup) to avoid thousands of writes.
        The UI polls at ~2s intervals, so 1s granularity is plenty."""
        if time.time() - self._last_save_ts >= min_interval:
            self.save()

    @staticmethod
    def load(account_id):
        path = os.path.join(config_manager.get_account_dir(account_id), "sync_progress.json")
        try:
            with open(path, "r") as f:
                data = json.load(f)
            p = SyncProgress(account_id)
            for k, v in data.items():
                if hasattr(p, k):
                    setattr(p, k, v)
            return p
        except (FileNotFoundError, json.JSONDecodeError):
            return SyncProgress(account_id)


def runner_alive(account_id):
    """Return True if a sync is currently running for this account.

    Probes the per-account flock: if it can be acquired non-blocking, no
    one is syncing; if not, a sync holds it (regardless of whether that's
    a sync_runner.py subprocess or a scheduler thread in our own process).
    This replaces a prior /proc cmdline scan which only matched
    sync_runner.py and mis-flagged scheduler-run syncs as crashed.
    Fails open (returns True) so transient lock errors don't clobber
    progress state.
    """
    lock_path = os.path.join(config_manager.get_account_dir(account_id), ".sync.lock")
    if not os.path.exists(os.path.dirname(lock_path)):
        return False
    fd = None
    try:
        fd = os.open(lock_path, os.O_CREAT | os.O_RDWR, 0o644)
        try:
            fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except OSError:
            return True  # lock held → sync is running
        try:
            fcntl.flock(fd, fcntl.LOCK_UN)
        except OSError:
            pass
        return False
    except OSError:
        return True
    finally:
        if fd is not None:
            try:
                os.close(fd)
            except OSError:
                pass


def heal_stale_progress(progress):
    """If progress claims syncing/starting but no runner exists, flip to
    'stopped' and persist. Returns True if a heal was applied. Use this
    everywhere progress.status is read for gating decisions, not just in
    the status poll -- otherwise a crashed runner blocks all writes until
    the UI polls."""
    if progress.status in ("syncing", "starting") and not runner_alive(progress.account_id):
        progress.status = "stopped"
        if not progress.finished_at:
            progress.finished_at = int(time.time())
        progress.error = progress.error or "Sync process not running (crashed or killed)"
        progress.save()
        return True
    return False


# Global flag to signal stop
_stop_flags = {}


def request_stop(account_id):
    _stop_flags[account_id] = True
    # Also leave a file marker so other processes (scheduler daemon,
    # detached sync_runner) see the stop request.
    try:
        stop_file = os.path.join(config_manager.get_account_dir(account_id), ".stop_sync")
        os.makedirs(os.path.dirname(stop_file), exist_ok=True)
        with open(stop_file, "w") as f:
            f.write(str(int(time.time())))
    except OSError:
        pass


def clear_stop(account_id):
    _stop_flags.pop(account_id, None)
    stop_file = os.path.join(config_manager.get_account_dir(account_id), ".stop_sync")
    try:
        os.remove(stop_file)
    except OSError:
        pass


def should_stop(account_id):
    if _stop_flags.get(account_id, False):
        return True
    # File-based signal written by the stop handler / request_stop() so
    # that syncs started in another process can also be stopped. We remove
    # the file on read AND set the in-memory flag in the same step: the
    # per-account lock guarantees only one process is in run_sync, so the
    # in-memory flag is the durable signal for the rest of this run. The
    # file is the cross-process channel and self-cleans, which avoids
    # stale .stop_sync files surviving a crash and blocking future syncs.
    stop_file = os.path.join(config_manager.get_account_dir(account_id), ".stop_sync")
    if os.path.exists(stop_file):
        _stop_flags[account_id] = True
        try:
            os.remove(stop_file)
        except OSError:
            pass
        return True
    return False


@contextlib.contextmanager
def _account_lock(account_id):
    """Per-account exclusive lock to prevent concurrent run_sync().

    Uses fcntl.flock on a file in the account dir. The lock is advisory
    but honored by us across processes (scheduler daemon + manual
    sync_runner subprocess). Yields True if acquired, False if another
    process holds it.
    """
    lock_path = os.path.join(config_manager.get_account_dir(account_id), ".sync.lock")
    os.makedirs(os.path.dirname(lock_path), exist_ok=True)
    fd = None
    acquired = False
    try:
        fd = os.open(lock_path, os.O_CREAT | os.O_RDWR, 0o644)
        try:
            fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
            acquired = True
        except OSError:
            acquired = False
        yield acquired
    finally:
        if fd is not None:
            try:
                if acquired:
                    fcntl.flock(fd, fcntl.LOCK_UN)
            except OSError:
                pass
            os.close(fd)


def run_sync(account_id):
    """Run a full sync for an account. Returns SyncProgress.

    Holds a per-account flock for the duration so a manually-triggered
    sync (sync_runner.py subprocess) can't race with the scheduler's
    in-process call for the same account. Without this, both would write
    to the manifest DB and progress JSON in parallel.
    """
    with _account_lock(account_id) as acquired:
        if not acquired:
            # Don't return SyncProgress.load() — the caller would see an
            # idle/complete state and think we ran. Reflect the actual
            # outcome: skipped because another sync holds the lock.
            LOGGER.info("Sync for %s skipped: another sync is already running", account_id)
            existing = SyncProgress.load(account_id)
            existing.status = existing.status if existing.status == "syncing" else "skipped"
            existing.error = "Sync already running for this account"
            return existing
        return _run_sync_locked(account_id)


def _run_sync_locked(account_id):
    progress = SyncProgress(account_id)
    # Clear any leftover in-memory flag from a previous run in this same
    # process (e.g. scheduler that ran a sync, was stopped, and is now
    # starting the next one). Don't remove the .stop_sync file here —
    # should_stop will pick it up and self-clean it on first check, so a
    # stop request that arrived just before this sync starts is honored.
    _stop_flags.pop(account_id, None)

    # Load config
    account = config_manager.get_account(account_id)
    if not account:
        progress.status = "error"
        progress.error = "Account not found"
        progress.save()
        return progress

    sync_config = config_manager.get_sync_config(account_id)
    raw_target = sync_config.get("target_dir", config_manager.DEFAULT_VOLUME + "/iCloudPhotos")
    target_dir = _resolve_target_dir(raw_target, account_id)

    if isinstance(target_dir, str) and target_dir.startswith("__UNRESOLVED_HOME__:"):
        progress.status = "error"
        progress.error = (
            "Konnte den DSM-Benutzer für das Home-Verzeichnis %r nicht "
            "ermitteln. Bitte einen expliziten Volume-Pfad wählen "
            "(z.B. %s/iCloudPhotos)." % (raw_target, config_manager.DEFAULT_VOLUME)
        )
        progress.save()
        return progress

    # Fail loudly if we cannot write to the configured target, rather than
    # silently redirecting — the user needs to know their pick doesn't work.
    if not _writable(target_dir):
        progress.status = "error"
        progress.error = (
            "Target directory %r is not writable by the package user "
            "'iCloudPhotoSync'. Re-select the folder in Settings — "
            "permissions are granted automatically.\n\n"
            "If the problem persists:\n"
            "1. Open Control Panel → Shared Folder\n"
            "2. Select the target share → Edit → Permissions tab\n"
            "3. Change the dropdown from 'Local Users' to "
            "'System internal user'\n"
            "4. Check 'Read/Write' for the 'iCloudPhotoSync' user\n"
            "5. Click Save"
        ) % target_dir
        progress.save()
        return progress

    # Authenticate
    client = icloud_client.get_client(account_id, account["apple_id"])
    if not client.restore_session():
        progress.status = "error"
        progress.error = "Not authenticated -- re-login required"
        progress.save()
        config_manager.update_account(account_id, {"status": "re_auth_needed"})
        return progress

    progress.status = "syncing"
    progress.started_at = int(time.time())
    progress.save()

    try:
        photos_svc = client.api.photos
    except Exception as e:
        from pyicloud_ipd.exceptions import (
            PyiCloudADPProtectionException,
            PyiCloudServiceNotActivatedException,
        )
        if isinstance(e, PyiCloudADPProtectionException):
            LOGGER.error(
                "iCloud Advanced Data Protection (ADP) appears to be enabled "
                "for account %s. ADP encrypts iCloud Photos end-to-end, "
                "blocking web-API access. Disable ADP or enable temporary "
                "web access at icloud.com.", account_id)
            progress.status = "error"
            progress.error = str(e)
            progress.save()
            return progress
        if isinstance(e, PyiCloudServiceNotActivatedException):
            LOGGER.error(
                "iCloud Photos is not available for account %s. "
                "Make sure iCloud Photos is enabled in the Apple ID "
                "settings for this account.", account_id)
            progress.status = "error"
            progress.error = str(e)
            progress.save()
            return progress
        raise

    try:
        # Build a plan with photo counts upfront so total_photos is a
        # stable denominator for the progress bar (no mid-run growth).
        plan = []  # (album_name, folder_key, subfolder, photo_count, latest_date)
        if sync_config.get("photostream", {}).get("enabled", True):
            try:
                ps_album = photos_svc.albums.get("All Photos")
                ps_count = ps_album.photo_count if ps_album else 0
            except Exception as e:
                from pyicloud_ipd.exceptions import PyiCloudADPProtectionException
                if isinstance(e, PyiCloudADPProtectionException):
                    LOGGER.error(
                        "ADP blocks access to iCloud Photos for account %s: %s",
                        account_id, e)
                    progress.status = "error"
                    progress.error = str(e)
                    progress.save()
                    return progress
                LOGGER.exception("Failed to get photo_count for All Photos")
                ps_count = 0
            plan.append(("All Photos", "photostream", "", ps_count, 0))

        if sync_config.get("albums", {}).get("enabled", True):
            selected = sync_config.get("albums", {}).get("selected", {})
            enabled_albums = [
                name for name, en in selected.items()
                if en and name != "All Photos"
            ]

            def _album_meta(name):
                try:
                    alb = photos_svc.albums.get(name)
                    if not alb or alb.album_type == "folder":
                        return (0, 0)
                    # CloudKit rejects resultsLimit<=2, photos() doubles
                    # internally (asset+master pairing), so limit=2.
                    first = alb.photos(limit=2, offset=0, direction="DESCENDING")
                    latest = first[0].created if first else 0
                    return (alb.photo_count or 0, latest)
                except Exception:
                    LOGGER.exception("Failed to get meta for album %s", name)
                    return (0, 0)

            album_metas = [(name,) + _album_meta(name) for name in enabled_albums]
            album_metas.sort(key=lambda t: t[2], reverse=True)
            for name, count, latest in album_metas:
                alb = photos_svc.albums.get(name)
                if alb and alb.parent_folder:
                    sub = os.path.join(_sanitize_path_component(alb.parent_folder), _sanitize_path_component(name))
                else:
                    sub = _sanitize_path_component(name)
                plan.append((name, "albums", sub, count, latest))

        if sync_config.get("shared_albums", {}).get("enabled", False):
            selected_shared = sync_config.get("shared_albums", {}).get("selected", {})
            enabled_shared = [name for name, en in selected_shared.items() if en]
            if enabled_shared:
                try:
                    shared = photos_svc.shared_albums
                    for name in enabled_shared:
                        alb = shared.get(name)
                        if alb:
                            try:
                                count = alb.photo_count or 0
                            except Exception:
                                count = 0
                            plan.append((name, "shared_albums", _sanitize_path_component(name), count, 0))
                except Exception:
                    LOGGER.exception("Failed to plan shared albums")

        if sync_config.get("shared_library", {}).get("enabled", False):
            try:
                sl_album = photos_svc.shared_library
                if sl_album:
                    sl_count = sl_album.photo_count or 0
                    plan.append(("Shared Library", "shared_library", "", sl_count, 0))
                else:
                    LOGGER.info("Shared Library enabled but no SharedSync zone found for account %s", account_id)
            except Exception:
                LOGGER.exception("Failed to plan shared library")

        progress.total_photos = sum(p[3] for p in plan)

        # Pre-seed skipped count from manifest so the progress bar starts
        # at the right percentage after a restart (instead of jumping to 0%).
        # Photos already in the manifest will not increment skipped_photos
        # again during dedup — see _dedup_preseeded flag in _sync_album.
        try:
            manifest_count = sync_manifest.count_unique_records(account_id)
            progress.skipped_photos = min(manifest_count, progress.total_photos)
        except Exception:
            LOGGER.debug("Could not pre-seed progress from manifest")

        progress.save()

        for album_name, folder_key, subfolder, _count, _latest in plan:
            if should_stop(account_id):
                break
            _sync_album(
                account_id, photos_svc, album_name,
                target_dir, sync_config, progress,
                folder_key=folder_key,
                subfolder=subfolder,
                client=client
            )

        if should_stop(account_id):
            progress.status = "stopped"
        else:
            progress.status = "complete"
        progress.finished_at = int(time.time())
        progress.save()

    except Exception as e:
        LOGGER.exception("Sync failed for account %s", account_id)
        progress.status = "error"
        progress.error = str(e)
        progress.finished_at = int(time.time())
        progress.save()

    clear_stop(account_id)
    return progress


def _sync_album(account_id, photos_svc, album_name, target_dir, sync_config, progress, folder_key, subfolder, client=None):
    """Sync a single album."""
    progress.current_album = album_name
    progress.save()

    if folder_key == "shared_library":
        album = photos_svc.shared_library
    elif folder_key == "shared_albums":
        album = photos_svc.shared_albums.get(album_name)
    else:
        album = photos_svc.albums.get(album_name)
    if not album:
        LOGGER.warning("Album not found: %s", album_name)
        return

    # Get folder structure config for this type
    folder_config = sync_config.get(folder_key, {})
    folder_structure = folder_config.get("folder_structure", "year_month" if folder_key == "photostream" else "flat")
    folder_builder = FOLDER_BUILDERS.get(folder_structure, FOLDER_BUILDERS["flat"])

    # total_photos is set upfront in run_sync from the plan — don't
    # grow it here or the progress bar denominator shifts mid-run.

    # Track paths created in this run to handle same-name conflicts.
    # Lock guards both _resolve_conflict's read and the .add() write since
    # the download pool below mutates this set from multiple worker threads.
    synced_this_run = set()
    synced_lock = threading.Lock()

    # Track record_ids processed in this run. CloudKit's paginated album
    # queries can return the same record in multiple batches (overlapping
    # ranks), which previously created _1/_2 suffixed duplicate hardlinks
    # because the DB-snapshot dedup below misses records added mid-run.
    seen_record_ids = set()

    # Get already synced records for dedup
    synced_checksums = sync_manifest.get_synced_checksums(account_id, album_name)

    # Fetch all photos from Apple (paginated). 400 is the largest size
    # CloudKit reliably honors; halves the number of HTTP roundtrips
    # versus 200 without triggering rate-limit responses in testing.
    batch_size = 400
    session = requests.Session()

    LOGGER.info("Syncing album '%s' (photo_count=%s)", album_name, album.photo_count)

    # Per-album perf accumulators (logged once at end of album).
    perf = {
        "fetch_wait": 0.0,   # time main thread blocked on Apple / queue
        "local": 0.0,        # time spent in dedup/exists/conflict loop
        "pairs": 0,          # total photos delivered by Apple
        "batches": 0,        # number of CloudKit batches consumed
        "exists_calls": 0,   # os.path.exists calls in dedup phase
        "exists_time": 0.0,  # cumulative time spent in those exists calls
    }
    progress_lock = threading.Lock()

    def _process_batch(photos, offset_for_log):
        """Run dedup, conflict, hardlink, and download for one batch."""
        if not photos:
            return
        perf["pairs"] += len(photos)
        perf["batches"] += 1
        LOGGER.info("Album '%s': batch at offset=%d, got %d photos",
                    album_name, offset_for_log, len(photos))

        _t_local = time.time()
        tasks = []
        for photo in photos:
            if should_stop(account_id):
                break

            if photo.id in seen_record_ids:
                LOGGER.debug("Skipped (pagination duplicate): %s in %s", photo.filename, album_name)
                continue
            seen_record_ids.add(photo.id)

            redownload_path = None
            if photo.id in synced_checksums:
                existing_checksum, existing_path = synced_checksums[photo.id]
                if existing_checksum and photo.checksum and existing_checksum == photo.checksum:
                    _t_ex = time.time()
                    _exists = os.path.exists(existing_path)
                    perf["exists_time"] += time.time() - _t_ex
                    perf["exists_calls"] += 1
                    if _exists:
                        LOGGER.debug("Skipped (dedup): %s in %s", photo.filename, album_name)
                        # Don't increment skipped_photos — these are already
                        # counted in the manifest pre-seed at sync start.
                        progress.save_throttled()
                        continue
                    else:
                        LOGGER.info("Re-downloading (file missing): %s", existing_path)
                        redownload_path = existing_path

            if redownload_path:
                dest_path = redownload_path
                final_path = redownload_path
                filename = os.path.basename(redownload_path)
            else:
                date_subfolder = folder_builder(photo.created)
                filename = _build_filename(photo, sync_config)

                if folder_key == "shared_library":
                    dest_dir = os.path.join(target_dir, "Shared Library", date_subfolder)
                elif folder_key == "shared_albums":
                    dest_dir = os.path.join(target_dir, "Shared", subfolder, date_subfolder)
                elif subfolder:
                    dest_dir = os.path.join(target_dir, "Albums", subfolder, date_subfolder)
                else:
                    dest_dir = os.path.join(target_dir, "Photostream", date_subfolder)

                if sync_config.get("format_folders"):
                    ext = os.path.splitext(filename)[1].upper().lstrip(".")
                    fmt_folder = ext if ext in ("HEIC", "JPG", "JPEG", "PNG", "MOV", "MP4") else "Other"
                    dest_dir = os.path.join(dest_dir, fmt_folder)

                dest_path = os.path.join(dest_dir, filename)

                with synced_lock:
                    final_path = _resolve_conflict(dest_path, sync_config, synced_this_run)
                    if final_path is None:
                        LOGGER.debug("Skipped (conflict): %s", dest_path)
                        progress.skipped_photos += 1
                        progress.save_throttled()
                        continue
                    # Reserve final_path immediately so a parallel batch can't
                    # pick the same name and race us to the file. Was dest_path
                    # before — that was wrong: rename-resolved final_path is
                    # what actually gets written.
                    synced_this_run.add(final_path)

            if sync_config.get("albums", {}).get("deduplicate_hardlinks", True) and not redownload_path:
                existing = sync_manifest.find_any_synced_path(account_id, photo.id)
                if existing and existing != final_path:
                    try:
                        os.makedirs(os.path.dirname(final_path), exist_ok=True)
                        try:
                            os.chmod(os.path.dirname(final_path), 0o755)
                        except OSError:
                            pass
                        os.link(existing, final_path)
                        ok = sync_manifest.mark_synced(
                            account_id, photo.id, album_name, filename, final_path,
                            checksum=photo.checksum, size=photo.size, created=photo.created
                        )
                        if not ok:
                            # Roll back the hardlink so the next sync sees a
                            # clean state (no orphan file without manifest row).
                            try:
                                os.remove(final_path)
                            except OSError:
                                pass
                            progress.failed_photos += 1
                            progress.save_throttled()
                            continue
                        with synced_lock:
                            synced_this_run.add(final_path)
                        progress.synced_photos += 1
                        progress.save_throttled()
                        LOGGER.debug("Hardlinked %s -> %s", existing, final_path)
                        continue
                    except OSError as e:
                        LOGGER.info("Hardlink failed (%s); falling back to download", e)

            download_url = photo.original_url
            if not download_url:
                LOGGER.warning("No download URL for %s", photo.filename)
                progress.failed_photos += 1
                progress.save_throttled()
                continue

            # final_path is already in synced_this_run (reserved at conflict
            # resolution above for the non-redownload branch). For redownload
            # we add it now so a parallel task can't grab the same path.
            if redownload_path:
                with synced_lock:
                    synced_this_run.add(final_path)
            tasks.append((photo, download_url, final_path, filename))

        perf["local"] += time.time() - _t_local

        if not tasks:
            return

        workers = max(1, min(8, int(sync_config.get("parallel_downloads", 4) or 4)))
        formats = sync_config.get("formats", "original")
        jpg_quality = max(10, min(100, int(sync_config.get("jpg_quality", 85) or 85)))

        # One-shot warning per sync if the user requested JPG output but no
        # converter is available. Without this, sync silently leaves HEIC
        # files in place and the user thinks conversion is broken.
        if formats in ("jpg_only", "both") and not heic_converter.can_convert():
            LOGGER.warning(
                "HEIC->JPG conversion requested (formats=%s) but no backend is "
                "available. HEIC files will be saved as-is. Install the "
                "SynoCommunity imagemagick package or reinstall this app with "
                "bundled binaries included.", formats,
            )

        def _process(task):
            """Returns (photo, fname, fpath, ok, is_conn_error, is_url_expired)."""
            photo, url, fpath, fname = task
            if should_stop(account_id):
                return (photo, fname, fpath, False, False, False)
            try:
                ok = _download_file(url, fpath, session=session)
            except _UrlExpiredError:
                return (photo, fname, fpath, False, False, True)
            except Exception as e:
                if _is_connection_error(e):
                    return (photo, fname, fpath, False, True, False)
                return (photo, fname, fpath, False, False, False)
            if not ok:
                return (photo, fname, fpath, False, False, False)
            if formats in ("jpg_only", "both") and heic_converter.is_heic(fname):
                if heic_converter.can_convert():
                    jpg_path = heic_converter.convert_to_jpg(fpath, quality=jpg_quality)
                    if jpg_path and formats == "jpg_only":
                        try:
                            os.remove(fpath)
                        except OSError:
                            pass
                        fpath = jpg_path
            return (photo, fname, fpath, True, False, False)

        pending_tasks = list(tasks)
        net_retries_used = 0
        url_refresh_used = 0
        _URL_REFRESH_MAX = 3

        while pending_tasks and not should_stop(account_id):
            pool = ThreadPoolExecutor(max_workers=workers)
            conn_retry_tasks = []
            expired_tasks = []
            consecutive_fails = 0
            network_failed = False
            futures = []
            try:
                futures = [pool.submit(_process, t) for t in pending_tasks]
                for fut in as_completed(futures):
                    if should_stop(account_id):
                        for f in futures:
                            f.cancel()
                        break
                    photo, fname, fpath, ok, is_conn_err, is_url_expired = fut.result()
                    with progress_lock:
                        if ok:
                            consecutive_fails = 0
                            if sync_manifest.mark_synced(
                                account_id, photo.id, album_name, fname, fpath,
                                checksum=photo.checksum, size=photo.size, created=photo.created
                            ):
                                progress.synced_photos += 1
                            else:
                                progress.failed_photos += 1
                        elif is_url_expired:
                            expired_tasks.append((photo, fpath, fname))
                        else:
                            if is_conn_err:
                                consecutive_fails += 1
                            else:
                                consecutive_fails = 0
                            if consecutive_fails >= _NET_CONSECUTIVE_FAIL and not network_failed:
                                LOGGER.warning(
                                    "Album '%s': %d consecutive connection errors — likely network outage",
                                    album_name, consecutive_fails)
                                network_failed = True
                            if network_failed and is_conn_err:
                                conn_retry_tasks.append((photo, photo.original_url, fpath, fname))
                            else:
                                progress.failed_photos += 1
                        progress.save_throttled()
            finally:
                pool.shutdown(wait=True)

            # Batch-refresh expired CDN URLs
            refresh_retry_tasks = []
            if expired_tasks and not should_stop(account_id):
                url_refresh_used += 1
                if url_refresh_used <= _URL_REFRESH_MAX:
                    refresh_photos = [t[0] for t in expired_tasks]
                    zone_id = (photos_svc._detect_shared_library_zone()
                               if folder_key == "shared_library" else None)
                    fresh_urls = {}
                    try:
                        fresh_urls = photos_svc.batch_refresh_photo_urls(
                            refresh_photos, zone_id=zone_id)
                    except Exception:
                        LOGGER.warning("Batch URL refresh failed, attempting session re-auth...")
                        try:
                            if client and client.restore_session():
                                photos_svc.session = client.api.session
                                fresh_urls = photos_svc.batch_refresh_photo_urls(
                                    refresh_photos, zone_id=zone_id)
                            else:
                                LOGGER.error("Session re-auth failed")
                        except Exception:
                            LOGGER.exception("Batch refresh failed after re-auth")
                    refreshed = 0
                    for photo, fpath, fname in expired_tasks:
                        url = fresh_urls.get(photo.id)
                        if url:
                            refresh_retry_tasks.append((photo, url, fpath, fname))
                            refreshed += 1
                        else:
                            with progress_lock:
                                progress.failed_photos += 1
                    if refreshed:
                        LOGGER.info("Batch-refreshed %d/%d expired URLs",
                                    refreshed, len(expired_tasks))
                else:
                    LOGGER.warning("Max URL refresh retries (%d) exhausted, "
                                   "counting %d as failed",
                                   _URL_REFRESH_MAX, len(expired_tasks))
                    with progress_lock:
                        progress.failed_photos += len(expired_tasks)
                        progress.save()

            retry_tasks = refresh_retry_tasks + conn_retry_tasks

            if not retry_tasks or should_stop(account_id):
                break

            # Handle connection retries with network wait
            if conn_retry_tasks:
                net_retries_used += 1
                if net_retries_used > _NET_RETRY_MAX:
                    LOGGER.warning("Album '%s': max network retries exhausted, counting %d as failed",
                                   album_name, len(conn_retry_tasks))
                    with progress_lock:
                        progress.failed_photos += len(conn_retry_tasks)
                        progress.save()
                    retry_tasks = refresh_retry_tasks
                    if not retry_tasks:
                        break
                else:
                    LOGGER.info("Album '%s': pausing for network recovery (%d files to retry, attempt %d/%d)",
                                album_name, len(conn_retry_tasks), net_retries_used, _NET_RETRY_MAX)
                    progress.error = "Waiting for network... (attempt %d/%d)" % (net_retries_used, _NET_RETRY_MAX)
                    progress.save()

                    if not _wait_for_connectivity(account_id):
                        LOGGER.warning("Album '%s': network not restored, counting %d as failed",
                                       album_name, len(conn_retry_tasks))
                        with progress_lock:
                            progress.failed_photos += len(conn_retry_tasks)
                            progress.save()
                        retry_tasks = refresh_retry_tasks
                        if not retry_tasks:
                            break

            progress.error = ""
            progress.save()
            pending_tasks = retry_tasks

        progress.save()

    total = album.photo_count or 0
    MULTI_TRACK_THRESHOLD = 1000
    NUM_TRACKS = 4

    if folder_key == "photostream" and total > MULTI_TRACK_THRESHOLD:
        # Multi-track: N producers fetch disjoint DESCENDING ranges in
        # parallel to hide Apple's ~13s/batch latency. Local processing
        # stays single-threaded on the main consumer (it's only ~3s total
        # compared to ~12min of fetch wait, so no point parallelizing it).
        q = Queue(maxsize=8)
        slice_size = (total + NUM_TRACKS - 1) // NUM_TRACKS

        def _producer(slice_start, slice_end):
            try:
                off = slice_end - 1
                while off >= slice_start and not should_stop(account_id):
                    limit = min(batch_size, off - slice_start + 1)
                    photos = None
                    for _retry in range(_NET_RETRY_MAX):
                        try:
                            photos = album.photos(limit=limit, offset=off, direction="DESCENDING")
                            break
                        except Exception as e:
                            LOGGER.exception("Producer fetch failed at offset=%d (attempt %d)", off, _retry + 1)
                            if _is_connection_error(e):
                                if not _wait_for_connectivity(account_id, max_cycles=3):
                                    break
                            else:
                                time.sleep(2 + _retry * 3)
                    if photos is None or should_stop(account_id):
                        break
                    if not photos:
                        break
                    q.put((off, photos))
                    off -= len(photos)
            finally:
                q.put(None)

        threads = []
        for i in range(NUM_TRACKS):
            s_start = i * slice_size
            s_end = min((i + 1) * slice_size, total)
            if s_start >= s_end:
                continue
            t = threading.Thread(target=_producer, args=(s_start, s_end), daemon=True)
            t.start()
            threads.append(t)

        LOGGER.info("Multi-track fetch: %d producers over %d photos", len(threads), total)
        remaining = len(threads)
        while remaining > 0 and not should_stop(account_id):
            _t_wait = time.time()
            item = q.get()
            perf["fetch_wait"] += time.time() - _t_wait
            if item is None:
                remaining -= 1
                continue
            off, photos = item
            _process_batch(photos, off)
    else:
        # Single-track with one-batch-ahead prefetch. Still useful for
        # user-created albums (ASCENDING) and for small photostreams.
        if folder_key == "photostream":
            direction = "DESCENDING"
            offset = max(total - 1, 0)
        else:
            direction = "ASCENDING"
            offset = 0

        def _fetch_with_retry(lim, off, dirn):
            for _retry in range(_NET_RETRY_MAX):
                try:
                    return album.photos(limit=lim, offset=off, direction=dirn)
                except Exception as e:
                    LOGGER.exception("Fetch failed at offset=%d (attempt %d)", off, _retry + 1)
                    if _is_connection_error(e):
                        if not _wait_for_connectivity(account_id, max_cycles=3):
                            return None
                    else:
                        time.sleep(2 + _retry * 3)
            return None

        fetch_pool = ThreadPoolExecutor(max_workers=1)
        next_future = fetch_pool.submit(_fetch_with_retry, batch_size, offset, direction)

        while not should_stop(account_id):
            _t_wait = time.time()
            photos = next_future.result()
            perf["fetch_wait"] += time.time() - _t_wait
            if not photos:
                break

            actual_step = len(photos) if direction == "ASCENDING" else -len(photos)
            next_offset = offset + actual_step
            if direction == "DESCENDING" and next_offset < 0:
                next_future = fetch_pool.submit(lambda: [])
            else:
                next_future = fetch_pool.submit(_fetch_with_retry, batch_size, next_offset, direction)

            _process_batch(photos, offset)

            if should_stop(account_id):
                break
            offset = next_offset

        fetch_pool.shutdown(wait=False)

    LOGGER.info(
        "PERF album='%s' batches=%d pairs=%d fetch_wait=%.1fs local=%.1fs exists_calls=%d exists_time=%.1fs",
        album_name, perf["batches"], perf["pairs"],
        perf["fetch_wait"], perf["local"], perf["exists_calls"], perf["exists_time"]
    )
