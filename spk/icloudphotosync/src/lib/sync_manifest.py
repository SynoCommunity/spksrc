"""
Sync Manifest — SQLite database tracking synced photos.

Each record maps an Apple record_id to a local file, with checksum for dedup.
"""
import logging
import os
import sqlite3
import time

import config_manager

LOGGER = logging.getLogger("sync_manifest")

DB_NAME = "sync_manifest.db"

_CREATE_SQL = """
CREATE TABLE IF NOT EXISTS synced_photos (
    record_id     TEXT NOT NULL,
    album         TEXT NOT NULL,
    filename      TEXT NOT NULL,
    local_path    TEXT NOT NULL,
    checksum      TEXT,
    size          INTEGER DEFAULT 0,
    created       INTEGER DEFAULT 0,
    synced_at     INTEGER NOT NULL,
    PRIMARY KEY (record_id, album)
);
CREATE INDEX IF NOT EXISTS idx_album ON synced_photos (album);
CREATE INDEX IF NOT EXISTS idx_checksum ON synced_photos (checksum);
CREATE INDEX IF NOT EXISTS idx_local_path ON synced_photos (local_path);
"""


def _db_path(account_id):
    return os.path.join(config_manager.get_account_dir(account_id), DB_NAME)


def _connect(account_id):
    path = _db_path(account_id)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    # timeout: wait up to 30s if another process holds the write lock.
    # WAL: lets readers (status handlers) proceed while a writer (sync)
    # is active, eliminating most "database is locked" errors.
    conn = sqlite3.connect(path, timeout=30.0)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA journal_mode=WAL")
    conn.execute("PRAGMA synchronous=NORMAL")
    conn.executescript(_CREATE_SQL)
    return conn


def is_synced(account_id, record_id, album, checksum=None):
    """Check if a photo is already synced (optionally with matching checksum)."""
    conn = _connect(account_id)
    try:
        if checksum:
            row = conn.execute(
                "SELECT 1 FROM synced_photos WHERE record_id=? AND album=? AND checksum=?",
                (record_id, album, checksum)
            ).fetchone()
        else:
            row = conn.execute(
                "SELECT 1 FROM synced_photos WHERE record_id=? AND album=?",
                (record_id, album)
            ).fetchone()
        return row is not None
    finally:
        conn.close()


def mark_synced(account_id, record_id, album, filename, local_path, checksum=None, size=0, created=0):
    """Record a photo as synced.

    Returns True on success, False on DB error. Callers that depend on the
    record actually being persisted (e.g. before deleting a source file)
    must check the return value rather than assuming success.
    """
    try:
        conn = _connect(account_id)
    except sqlite3.Error:
        LOGGER.exception("mark_synced: DB connect failed for %s/%s", account_id, record_id)
        return False
    try:
        try:
            conn.execute(
                """INSERT OR REPLACE INTO synced_photos
                   (record_id, album, filename, local_path, checksum, size, created, synced_at)
                   VALUES (?, ?, ?, ?, ?, ?, ?, ?)""",
                (record_id, album, filename, local_path, checksum, size, created, int(time.time()))
            )
            conn.commit()
            return True
        except sqlite3.Error:
            LOGGER.exception("mark_synced: write failed for %s/%s", account_id, record_id)
            return False
    finally:
        conn.close()


def find_any_synced_path(account_id, record_id):
    """Return a local_path for any existing manifest row with this
    record_id (across all albums). Used to short-circuit a re-download
    by hardlinking an already-downloaded copy from Photostream or a
    sibling album. Returns None if no such row exists.
    """
    conn = _connect(account_id)
    try:
        rows = conn.execute(
            "SELECT local_path FROM synced_photos WHERE record_id=?",
            (record_id,)
        ).fetchall()
        for r in rows:
            p = r["local_path"]
            if p and os.path.exists(p):
                return p
        return None
    finally:
        conn.close()


def get_synced_ids(account_id, album):
    """Get set of record_ids already synced for an album."""
    conn = _connect(account_id)
    try:
        rows = conn.execute(
            "SELECT record_id FROM synced_photos WHERE album=?",
            (album,)
        ).fetchall()
        return {r["record_id"] for r in rows}
    finally:
        conn.close()


def get_synced_checksums(account_id, album):
    """Get dict of record_id -> (checksum, local_path) for an album."""
    conn = _connect(account_id)
    try:
        rows = conn.execute(
            "SELECT record_id, checksum, local_path FROM synced_photos WHERE album=?",
            (album,)
        ).fetchall()
        return {r["record_id"]: (r["checksum"], r["local_path"]) for r in rows}
    finally:
        conn.close()


def get_stats(account_id):
    """Get sync statistics for an account."""
    conn = _connect(account_id)
    try:
        total = conn.execute("SELECT COUNT(*) as c FROM synced_photos").fetchone()["c"]
        albums = conn.execute("SELECT COUNT(DISTINCT album) as c FROM synced_photos").fetchone()["c"]
        last = conn.execute("SELECT MAX(synced_at) as t FROM synced_photos").fetchone()["t"]
        total_size = conn.execute("SELECT SUM(size) as s FROM synced_photos").fetchone()["s"] or 0
        return {
            "total_synced": total,
            "albums_synced": albums,
            "last_sync": last or 0,
            "total_size": total_size,
        }
    finally:
        conn.close()


def count_unique_records(account_id):
    """Count distinct record_ids across all albums for an account."""
    conn = _connect(account_id)
    try:
        row = conn.execute("SELECT COUNT(DISTINCT record_id) as c FROM synced_photos").fetchone()
        return row["c"] if row else 0
    finally:
        conn.close()


def remove_album(account_id, album):
    """Remove all sync records for an album."""
    conn = _connect(account_id)
    try:
        conn.execute("DELETE FROM synced_photos WHERE album=?", (album,))
        conn.commit()
    finally:
        conn.close()


def all_rows(account_id):
    """Return all synced rows for an account, ordered so duplicate inodes
    (hardlinks) are seen in a stable order. local_path sort groups paths
    under the same root and keeps Photostream before Albums alphabetically.
    """
    conn = _connect(account_id)
    try:
        rows = conn.execute(
            "SELECT record_id, album, filename, local_path, size FROM synced_photos "
            "ORDER BY local_path"
        ).fetchall()
        return [dict(r) for r in rows]
    finally:
        conn.close()


def update_path(account_id, record_id, album, new_path):
    """Update local_path for a specific synced row."""
    conn = _connect(account_id)
    try:
        conn.execute(
            "UPDATE synced_photos SET local_path=? WHERE record_id=? AND album=?",
            (new_path, record_id, album)
        )
        conn.commit()
    finally:
        conn.close()


def clear_all(account_id):
    """Remove all sync records for an account (e.g. when target_dir changes)."""
    conn = _connect(account_id)
    try:
        conn.execute("DELETE FROM synced_photos")
        conn.commit()
    finally:
        conn.close()
