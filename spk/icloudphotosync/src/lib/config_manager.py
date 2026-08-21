"""
Config Manager — reads/writes JSON config for iCloud Photo Sync.

Config is stored at /var/packages/iCloudPhotoSync/var/config.json
Per-account data is in /var/packages/iCloudPhotoSync/var/accounts/{account_id}/
"""
import contextlib
import json
import os
import threading
import uuid

try:
    import fcntl
except ImportError:  # Windows dev boxes
    fcntl = None

_config_tlock = threading.Lock()


def _detect_default_volume():
    """Find the first available /volumeN on this NAS.

    Most Synology boxes use /volume1 but some (e.g. after pool migration)
    only have /volume2 or /volume3.  We scan for the lowest-numbered
    volume directory that actually exists.
    """
    try:
        import glob
        vols = sorted(glob.glob("/volume[0-9]*"))
        for v in vols:
            if os.path.isdir(v) and not v.endswith("USB") and "@" not in v:
                return v
    except Exception:
        pass
    return "/volume1"


DEFAULT_VOLUME = _detect_default_volume()


PKG_VAR = os.environ.get(
    "SYNOPKG_PKGVAR",
    "/var/packages/iCloudPhotoSync/var"
)

CONFIG_FILE = os.path.join(PKG_VAR, "config.json")
ACCOUNTS_DIR = os.path.join(PKG_VAR, "accounts")


def _ensure_dirs():
    os.makedirs(PKG_VAR, exist_ok=True)
    os.makedirs(ACCOUNTS_DIR, exist_ok=True)


def atomic_write_json(path, data, indent=None):
    """Write JSON to path atomically: temp file + fsync + rename.

    Multiple CGI handlers and the scheduler can hit the same JSON file
    concurrently. A direct overwrite leaves a window where another reader
    sees a truncated or empty file. os.replace is atomic on POSIX.
    """
    tmp = path + ".tmp"
    with open(tmp, "w") as f:
        if indent is not None:
            json.dump(data, f, indent=indent)
        else:
            json.dump(data, f)
        f.flush()
        try:
            os.fsync(f.fileno())
        except OSError:
            pass
    os.replace(tmp, path)


@contextlib.contextmanager
def _locked(lock_path):
    """Serialise read-modify-write cycles across threads AND processes.

    Two accounts updating different fields of config.json concurrently would
    otherwise produce lost updates: both read the same base, each writes back
    its own change, second writer wins. The threading.Lock covers in-process
    parallel scheduler threads; fcntl.flock covers CGI handlers running in
    sibling processes.
    """
    _ensure_dirs()
    _config_tlock.acquire()
    fd = None
    try:
        if fcntl is not None:
            try:
                fd = os.open(lock_path, os.O_RDWR | os.O_CREAT, 0o644)
                fcntl.flock(fd, fcntl.LOCK_EX)
            except OSError:
                if fd is not None:
                    try:
                        os.close(fd)
                    except OSError:
                        pass
                    fd = None
        yield
    finally:
        if fd is not None:
            try:
                fcntl.flock(fd, fcntl.LOCK_UN)
            except OSError:
                pass
            try:
                os.close(fd)
            except OSError:
                pass
        _config_tlock.release()


def load_config():
    _ensure_dirs()
    if os.path.isfile(CONFIG_FILE):
        try:
            with open(CONFIG_FILE, "r") as f:
                return json.load(f)
        except json.JSONDecodeError:
            # Corrupted (e.g. concurrent write before atomic_write_json
            # was introduced). Fall back to defaults rather than crash.
            pass
    return {"accounts": [], "log_level": "INFO"}


def save_config(config):
    _ensure_dirs()
    atomic_write_json(CONFIG_FILE, config, indent=2)


def get_accounts():
    config = load_config()
    return config.get("accounts", [])


def get_account(account_id):
    for acc in get_accounts():
        if acc["id"] == account_id:
            return acc
    return None


def add_account(apple_id):
    with _locked(CONFIG_FILE + ".lock"):
        config = load_config()
        account_id = str(uuid.uuid4())[:8]
        account = {
            "id": account_id,
            "apple_id": apple_id,
            "status": "pending_2fa",
            "photo_count": 0,
            "added": None,
        }
        config.setdefault("accounts", []).append(account)
        save_config(config)

    # Create per-account directory for session data
    account_dir = os.path.join(ACCOUNTS_DIR, account_id)
    os.makedirs(account_dir, exist_ok=True)

    return account


def update_account(account_id, updates):
    with _locked(CONFIG_FILE + ".lock"):
        config = load_config()
        for acc in config.get("accounts", []):
            if acc["id"] == account_id:
                acc.update(updates)
                save_config(config)
                return acc
    return None


def remove_account(account_id):
    with _locked(CONFIG_FILE + ".lock"):
        config = load_config()
        accounts = config.get("accounts", [])
        config["accounts"] = [a for a in accounts if a["id"] != account_id]
        save_config(config)

    # Clean up per-account directory
    import shutil
    account_dir = os.path.join(ACCOUNTS_DIR, account_id)
    if os.path.isdir(account_dir):
        shutil.rmtree(account_dir, ignore_errors=True)


def get_account_dir(account_id):
    return os.path.join(ACCOUNTS_DIR, account_id)


# --- Temporary password storage for pending 2FA ---
# Stored in /dev/shm (tmpfs / RAM-only) so the password never touches disk.
# Falls back to the per-account directory when /dev/shm is unavailable.
# Encryption: PBKDF2-derived keystream with random salt + HMAC-SHA256
# authentication. The key is derived from machine-id + account-id + a
# 16-byte random salt, so every encryption produces different ciphertext
# and the file alone is useless without the machine identity.

import hashlib
import hmac

_SHM_DIR = "/dev/shm"
_MACHINE_ID_PATHS = ("/etc/machine-id", "/var/lib/dbus/machine-id", "/etc/synoinfo.conf")

_PBKDF2_ITERATIONS = 100_000
_SALT_LEN = 16
_HMAC_LEN = 32


def _pending_pw_path(account_id):
    if os.path.isdir(_SHM_DIR):
        return os.path.join(_SHM_DIR, "icloudphotosync_pw_%s" % account_id)
    return os.path.join(ACCOUNTS_DIR, account_id, ".pending_pw")


def _get_machine_id():
    for path in _MACHINE_ID_PATHS:
        try:
            with open(path, "r") as f:
                return f.read().strip()
        except OSError:
            continue
    return ""


def _derive_keys(account_id, salt):
    seed = ("icloudphotosync:%s:%s" % (_get_machine_id(), account_id)).encode()
    key_block = hashlib.pbkdf2_hmac("sha256", seed, salt, _PBKDF2_ITERATIONS, dklen=64)
    return key_block[:32], key_block[32:]


def _keystream_encrypt(data, key):
    out = bytearray()
    for i in range(0, len(data), 32):
        block_key = hashlib.sha256(key + i.to_bytes(4, "big")).digest()
        chunk = data[i:i + 32]
        out.extend(b ^ block_key[j] for j, b in enumerate(chunk))
    return bytes(out)


def save_pending_password(account_id, password):
    """Store password encrypted temporarily while waiting for 2FA."""
    pw_file = _pending_pw_path(account_id)
    if not pw_file.startswith(_SHM_DIR):
        os.makedirs(os.path.join(ACCOUNTS_DIR, account_id), exist_ok=True)

    salt = os.urandom(_SALT_LEN)
    enc_key, hmac_key = _derive_keys(account_id, salt)
    ciphertext = _keystream_encrypt(password.encode("utf-8"), enc_key)
    mac = hmac.new(hmac_key, salt + ciphertext, "sha256").digest()

    fd = os.open(pw_file, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600)
    with os.fdopen(fd, "wb") as f:
        f.write(salt)
        f.write(mac)
        f.write(ciphertext)


def get_pending_password(account_id):
    """Retrieve and decrypt temporarily stored password, or None."""
    pw_file = _pending_pw_path(account_id)
    try:
        with open(pw_file, "rb") as f:
            blob = f.read()
    except FileNotFoundError:
        return None

    if len(blob) < _SALT_LEN + _HMAC_LEN + 1:
        return None

    salt = blob[:_SALT_LEN]
    stored_mac = blob[_SALT_LEN:_SALT_LEN + _HMAC_LEN]
    ciphertext = blob[_SALT_LEN + _HMAC_LEN:]

    enc_key, hmac_key = _derive_keys(account_id, salt)
    expected_mac = hmac.new(hmac_key, salt + ciphertext, "sha256").digest()
    if not hmac.compare_digest(stored_mac, expected_mac):
        return None

    plaintext = _keystream_encrypt(ciphertext, enc_key)
    try:
        return plaintext.decode("utf-8")
    except UnicodeDecodeError:
        return None


def clear_pending_password(account_id):
    """Remove temporarily stored password."""
    pw_file = _pending_pw_path(account_id)
    try:
        os.remove(pw_file)
    except FileNotFoundError:
        pass


# --- Per-account sync configuration ---

def _sync_config_path(account_id):
    return os.path.join(ACCOUNTS_DIR, account_id, "sync_config.json")


def get_sync_config(account_id):
    """Get sync configuration for an account."""
    path = _sync_config_path(account_id)
    defaults = {
        "target_dir": DEFAULT_VOLUME + "/iCloudPhotos",
        "photostream": {
            "enabled": True,
            "folder_structure": "year_month",  # year_month_day, year_month, year, flat
        },
        "albums": {
            "enabled": True,
            "folder_structure": "flat",  # year_month_day, year_month, year, flat
            "selected": {},  # album_name -> True/False
            "deduplicate_hardlinks": True,  # hardlink instead of re-downloading duplicates
        },
        "shared_albums": {
            "enabled": False,
            "folder_structure": "flat",
            "selected": {},
        },
        "shared_library": {
            "enabled": False,
            "folder_structure": "year_month",
        },
        "filenames": "original",  # original, date_based
        "conflict": "skip",  # skip, overwrite, rename
        "formats": "original",  # original, jpg_only, both
        "jpg_quality": 85,  # 10-100, JPEG quality for HEIC conversion
        "format_folders": False,  # separate HEIC/JPG subfolders
        "parallel_downloads": 4,  # 1, 2, 4, 8
        "sync_interval_hours": 6,
    }

    try:
        with open(path, "r") as f:
            saved = json.load(f)
        # Merge saved over defaults (keeps new defaults for missing keys)
        for k, v in saved.items():
            if isinstance(v, dict) and isinstance(defaults.get(k), dict):
                defaults[k].update(v)
            else:
                defaults[k] = v
        return defaults
    except (FileNotFoundError, json.JSONDecodeError):
        return defaults


def save_sync_config(account_id, config):
    """Save sync configuration for an account."""
    os.makedirs(os.path.join(ACCOUNTS_DIR, account_id), exist_ok=True)
    path = _sync_config_path(account_id)
    atomic_write_json(path, config, indent=2)


def set_album_sync(account_id, album_name, enabled):
    """Toggle sync for a specific album."""
    with _locked(_sync_config_path(account_id) + ".lock"):
        config = get_sync_config(account_id)
        config["albums"]["selected"][album_name] = enabled
        save_sync_config(account_id, config)
    return config


def set_shared_album_sync(account_id, album_name, enabled):
    """Toggle sync for a shared album."""
    with _locked(_sync_config_path(account_id) + ".lock"):
        config = get_sync_config(account_id)
        config.setdefault("shared_albums", {}).setdefault("selected", {})[album_name] = enabled
        save_sync_config(account_id, config)
    return config
