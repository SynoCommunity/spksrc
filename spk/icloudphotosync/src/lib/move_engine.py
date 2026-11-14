"""
Move Engine — moves already-synced photos to a new target directory.

Handles two cases:
  - Same volume: os.rename per file (atomic, preserves hardlinks).
  - Cross volume: copy + delete, with an inode map so hardlinks in the
    old tree are re-established in the new tree.

Manifest is updated per file AFTER a successful move, so a crash/abort
leaves the DB consistent (the unmoved remainder still points to old
paths and can be resumed by starting the move again with the same
old/new pair).
"""
import json
import logging
import os
import shutil
import time

import config_manager
import sync_manifest

LOGGER = logging.getLogger("move_engine")

_stop_flags = {}


def request_stop(account_id):
    _stop_flags[account_id] = True


def clear_stop(account_id):
    _stop_flags.pop(account_id, None)


def should_stop(account_id):
    if _stop_flags.get(account_id, False):
        return True
    stop_file = os.path.join(config_manager.get_account_dir(account_id), ".stop_move")
    if os.path.exists(stop_file):
        try:
            os.remove(stop_file)
        except OSError:
            pass
        _stop_flags[account_id] = True
        return True
    return False


class MoveProgress:
    def __init__(self, account_id):
        self.account_id = account_id
        self.status = "idle"  # idle, starting, moving, error, complete, stopped
        self.total_files = 0
        self.moved_files = 0
        self.failed_files = 0
        self.bytes_total = 0
        self.bytes_moved = 0
        self.current_file = ""
        self.old_dir = ""
        self.new_dir = ""
        self.same_volume = False
        self.started_at = 0
        self.finished_at = 0
        self.error = ""

    def to_dict(self):
        return {
            "status": self.status,
            "total_files": self.total_files,
            "moved_files": self.moved_files,
            "failed_files": self.failed_files,
            "bytes_total": self.bytes_total,
            "bytes_moved": self.bytes_moved,
            "current_file": self.current_file,
            "old_dir": self.old_dir,
            "new_dir": self.new_dir,
            "same_volume": self.same_volume,
            "started_at": self.started_at,
            "finished_at": self.finished_at,
            "error": self.error,
        }

    def save(self):
        path = os.path.join(config_manager.get_account_dir(self.account_id), "move_progress.json")
        try:
            config_manager.atomic_write_json(path, self.to_dict())
        except Exception:
            LOGGER.exception("MoveProgress.save failed for %s", self.account_id)

    @staticmethod
    def load(account_id):
        path = os.path.join(config_manager.get_account_dir(account_id), "move_progress.json")
        try:
            with open(path, "r") as f:
                data = json.load(f)
            p = MoveProgress(account_id)
            for k, v in data.items():
                if hasattr(p, k):
                    setattr(p, k, v)
            return p
        except (FileNotFoundError, json.JSONDecodeError):
            return MoveProgress(account_id)


def _remove_empty_tree(root):
    """Remove empty dirs bottom-up under root. Silent on errors."""
    if not os.path.isdir(root):
        return
    for dirpath, _, _ in os.walk(root, topdown=False):
        try:
            if not os.listdir(dirpath):
                os.rmdir(dirpath)
        except OSError:
            pass


def run_move(account_id, old_dir, new_dir):
    """Move all manifest-tracked files from old_dir to new_dir.

    Returns MoveProgress. Idempotent per-file (if new_path already exists
    we just update the manifest row and skip the physical move).
    """
    progress = MoveProgress(account_id)
    progress.old_dir = old_dir
    progress.new_dir = new_dir
    progress.status = "starting"
    progress.started_at = int(time.time())
    progress.save()
    clear_stop(account_id)

    if not old_dir or not new_dir:
        progress.status = "error"
        progress.error = "Quell- oder Zielordner fehlt."
        progress.save()
        return progress

    if os.path.abspath(old_dir) == os.path.abspath(new_dir):
        progress.status = "complete"
        progress.finished_at = int(time.time())
        progress.save()
        return progress

    try:
        os.makedirs(new_dir, exist_ok=True)
    except OSError as e:
        progress.status = "error"
        progress.error = "Zielordner nicht anlegbar: %s" % e
        progress.save()
        return progress

    # Detect same-volume. If old_dir doesn't exist anymore (moved already)
    # we still need to allow the run to complete by just updating manifest
    # paths for any remaining rows that point into new_dir.
    try:
        old_st = os.stat(old_dir).st_dev
        new_st = os.stat(new_dir).st_dev
        progress.same_volume = (old_st == new_st)
    except OSError:
        progress.same_volume = False

    rows = sync_manifest.all_rows(account_id)
    progress.total_files = len(rows)
    progress.bytes_total = sum((r.get("size") or 0) for r in rows)
    progress.status = "moving"
    progress.save()

    LOGGER.info("Move %s -> %s (same_volume=%s, %d files, %.1f MB)",
                old_dir, new_dir, progress.same_volume,
                progress.total_files, progress.bytes_total / 1048576.0)

    # Cross-volume hardlink preservation: first time we see an inode we
    # copy, then any further manifest rows pointing at the same inode are
    # re-linked to the newly-copied file. Same-volume os.rename preserves
    # inodes natively, so this map stays unused.
    inode_to_new = {}

    last_save = time.time()

    for i, row in enumerate(rows):
        if should_stop(account_id):
            progress.status = "stopped"
            break

        old_path = row["local_path"]
        record_id = row["record_id"]
        album = row["album"]

        # Rows pointing outside old_dir (e.g. leftover from a previous
        # partial move) are handled by their own prefix: if they already
        # live under new_dir, just verify and count as moved.
        if old_path.startswith(new_dir + os.sep) or old_path == new_dir:
            if os.path.exists(old_path):
                progress.moved_files += 1
                progress.bytes_moved += row.get("size") or 0
            else:
                progress.failed_files += 1
            continue

        if not old_path.startswith(old_dir + os.sep) and old_path != old_dir:
            LOGGER.warning("Skipping row with path outside old_dir: %s", old_path)
            progress.failed_files += 1
            continue

        rel = os.path.relpath(old_path, old_dir)
        new_path = os.path.join(new_dir, rel)
        progress.current_file = rel

        # File already at destination? (e.g. resumed run)
        if os.path.exists(new_path) and not os.path.exists(old_path):
            sync_manifest.update_path(account_id, record_id, album, new_path)
            progress.moved_files += 1
            progress.bytes_moved += row.get("size") or 0
        elif not os.path.exists(old_path):
            LOGGER.info("Source missing, skipping: %s", old_path)
            progress.failed_files += 1
        else:
            try:
                os.makedirs(os.path.dirname(new_path), exist_ok=True)
                try:
                    os.chmod(os.path.dirname(new_path), 0o755)
                except OSError:
                    pass

                if progress.same_volume:
                    # os.rename overwrites the destination on POSIX. If
                    # new_path already exists and isn't the same inode as
                    # old_path, that's an unrelated file we'd silently
                    # destroy — refuse instead.
                    if os.path.exists(new_path):
                        try:
                            same = os.path.samefile(old_path, new_path)
                        except OSError:
                            same = False
                        if not same:
                            LOGGER.warning(
                                "Refusing to overwrite existing destination: %s", new_path
                            )
                            progress.failed_files += 1
                            progress.error = "Ziel existiert bereits: %s" % rel
                            continue
                        # Same inode (already moved+hardlinked): just refresh
                        # the manifest path and drop the duplicate at old_path.
                        sync_manifest.update_path(account_id, record_id, album, new_path)
                        try:
                            os.remove(old_path)
                        except OSError:
                            pass
                        progress.moved_files += 1
                        progress.bytes_moved += row.get("size") or 0
                        continue
                    os.rename(old_path, new_path)
                    sync_manifest.update_path(account_id, record_id, album, new_path)
                    progress.moved_files += 1
                    progress.bytes_moved += row.get("size") or 0
                else:
                    try:
                        old_inode = os.stat(old_path).st_ino
                    except OSError:
                        old_inode = None

                    if old_inode is not None and old_inode in inode_to_new:
                        os.link(inode_to_new[old_inode], new_path)
                    else:
                        shutil.copy2(old_path, new_path)
                        if old_inode is not None:
                            inode_to_new[old_inode] = new_path
                    # Only update the manifest after the source is gone.
                    # If remove fails we leave the manifest pointing to
                    # old_path so the next move attempt can retry; otherwise
                    # we'd orphan the file at old_path with no record.
                    try:
                        os.remove(old_path)
                    except OSError as rm_err:
                        LOGGER.warning(
                            "Copied to %s but could not remove source %s: %s "
                            "(manifest left at old path; will retry)",
                            new_path, old_path, rm_err
                        )
                        progress.failed_files += 1
                        progress.error = "Quelle nicht löschbar: %s" % rel
                        continue

                    sync_manifest.update_path(account_id, record_id, album, new_path)
                    progress.moved_files += 1
                    progress.bytes_moved += row.get("size") or 0
            except OSError as e:
                LOGGER.exception("Failed to move %s -> %s", old_path, new_path)
                progress.failed_files += 1
                progress.error = "%s: %s" % (os.path.basename(old_path), e)

        # Throttle progress saves to ~once per second.
        if time.time() - last_save > 1.0:
            progress.save()
            last_save = time.time()

    # Tidy up: remove now-empty directories under the old root.
    if progress.status != "stopped":
        _remove_empty_tree(old_dir)
        progress.status = "complete"

    progress.current_file = ""
    progress.finished_at = int(time.time())
    progress.save()
    return progress
