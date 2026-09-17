#!/usr/bin/env python3
"""
iCloud Photo Sync — API endpoint served via /webman/3rdparty/iCloudPhotoSync/api.cgi

Routes requests based on the 'method' parameter to the appropriate handler
in the lib/handlers/ directory.
"""
import json
import os
import sys
import cgi
import urllib.parse

# The app/ dir lives at /var/packages/iCloudPhotoSync/target/app/
# The lib/ dir lives at /var/packages/iCloudPhotoSync/target/lib/
PKG_TARGET = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
LIB_DIR = os.path.join(PKG_TARGET, "lib")
VENDOR_DIR = os.path.join(LIB_DIR, "vendor")
sys.path.insert(0, LIB_DIR)
if os.path.isdir(VENDOR_DIR):
    sys.path.insert(0, VENDOR_DIR)

from handlers import status as status_handler
from handlers import auth as auth_handler
from handlers import account as account_handler
from handlers import album as album_handler
from handlers import sync as sync_handler
from handlers import config as config_handler
from handlers import log as log_handler
from handlers import move as move_handler

HANDLERS = {
    "status": status_handler.handle,
    "auth": auth_handler.handle,
    "account": account_handler.handle,
    "album": album_handler.handle,
    "sync": sync_handler.handle,
    "config": config_handler.handle,
    "log": log_handler.handle,
    "move": move_handler.handle,
}


def respond(success, data=None, error=None, total=None):
    result = {"success": success}
    if data is not None:
        result["data"] = data
    if error is not None:
        result["error"] = error
    if total is not None:
        result["total"] = total
    body = json.dumps(result)
    print("Content-Type: application/json")
    print("Content-Length: %d" % len(body))
    print()
    print(body)


def _is_icloud_url(url):
    """Validate that url points to an Apple iCloud content domain."""
    try:
        parsed = urllib.parse.urlparse(url)
        host = (parsed.hostname or "").lower()
        return (
            parsed.scheme in ("http", "https")
            and (host.endswith(".icloud-content.com") or host == "icloud-content.com")
        )
    except Exception:
        return False


def proxy_thumb():
    """Proxy iCloud thumbnail to avoid mixed-content browser block."""
    params = cgi.FieldStorage()
    url = params.getvalue("url", "")
    if not url or not _is_icloud_url(url):
        print("Status: 400 Bad Request")
        print("Content-Type: text/plain")
        print()
        print("Invalid URL")
        return

    import requests
    try:
        r = requests.get(url, timeout=15)
        ct = r.headers.get("Content-Type", "image/jpeg")
        sys.stdout.buffer.write(("Content-Type: %s\r\n" % ct).encode())
        sys.stdout.buffer.write(("Content-Length: %d\r\n" % len(r.content)).encode())
        sys.stdout.buffer.write(("Cache-Control: public, max-age=86400\r\n").encode())
        sys.stdout.buffer.write(b"\r\n")
        sys.stdout.buffer.write(r.content)
    except Exception:
        print("Status: 502 Bad Gateway")
        print("Content-Type: text/plain")
        print()
        print("Fetch failed")


def _safe_filename(name, fallback="photo.jpg"):
    """Strip path separators and control chars from filename."""
    if not name:
        return fallback
    name = name.replace("\\", "_").replace("/", "_").replace("\r", "").replace("\n", "")
    name = name.strip(". ")
    return name or fallback


def download_photo():
    """Stream a single iCloud asset to the browser as file download."""
    params = cgi.FieldStorage()
    url = params.getvalue("url", "")
    filename = _safe_filename(params.getvalue("filename", ""))
    if not url or not _is_icloud_url(url):
        print("Status: 400 Bad Request")
        print("Content-Type: text/plain")
        print()
        print("Invalid URL")
        return

    import requests
    try:
        r = requests.get(url, timeout=60, stream=True)
        ct = r.headers.get("Content-Type", "application/octet-stream")
        cl = r.headers.get("Content-Length")
        sys.stdout.buffer.write(("Content-Type: %s\r\n" % ct).encode())
        if cl:
            sys.stdout.buffer.write(("Content-Length: %s\r\n" % cl).encode())
        sys.stdout.buffer.write(
            ('Content-Disposition: attachment; filename="%s"\r\n' % filename).encode()
        )
        sys.stdout.buffer.write(b"\r\n")
        for chunk in r.iter_content(chunk_size=65536):
            if chunk:
                sys.stdout.buffer.write(chunk)
    except Exception:
        print("Status: 502 Bad Gateway")
        print("Content-Type: text/plain")
        print()
        print("Fetch failed")


def download_zip(raw_body):
    """Stream a ZIP bundle of multiple iCloud assets. Expects JSON POST body:
    {"items": [{"url": "...", "filename": "..."}, ...], "zipname": "photos.zip"}
    """
    import zipfile, io, requests
    try:
        payload = json.loads(raw_body or "{}")
        items = payload.get("items") or []
        zipname = _safe_filename(payload.get("zipname") or "photos.zip", "photos.zip")
    except Exception as e:
        print("Status: 400 Bad Request")
        print("Content-Type: text/plain")
        print()
        print("Invalid payload: %s" % e)
        return

    items = [it for it in items if it.get("url") and _is_icloud_url(it["url"])]
    if not items:
        print("Status: 400 Bad Request")
        print("Content-Type: text/plain")
        print()
        print("No valid items")
        return

    buf = io.BytesIO()
    used = {}
    failed = []
    with zipfile.ZipFile(buf, "w", zipfile.ZIP_STORED, allowZip64=True) as zf:
        for it in items:
            raw_name = _safe_filename(it.get("filename"))
            n = used.get(raw_name, 0)
            used[raw_name] = n + 1
            name = raw_name
            if n > 0:
                dot = raw_name.rfind(".")
                if dot > 0:
                    name = "%s_%d%s" % (raw_name[:dot], n, raw_name[dot:])
                else:
                    name = "%s_%d" % (raw_name, n)
            try:
                resp = requests.get(it["url"], timeout=60)
                if resp.status_code != 200:
                    failed.append(raw_name)
                    continue
                zf.writestr(name, resp.content)
            except Exception:
                failed.append(raw_name)
                continue

    data = buf.getvalue()
    sys.stdout.buffer.write(b"Content-Type: application/zip\r\n")
    sys.stdout.buffer.write(("Content-Length: %d\r\n" % len(data)).encode())
    sys.stdout.buffer.write(
        ('Content-Disposition: attachment; filename="%s"\r\n' % zipname).encode()
    )
    if failed:
        # Comma-joined filenames; ASCII only (header-safe). Non-ASCII names are
        # escaped to avoid breaking the HTTP response.
        safe_list = ",".join(nm.encode("ascii", "replace").decode("ascii") for nm in failed)
        sys.stdout.buffer.write(("X-Export-Failed: %s\r\n" % safe_list).encode())
    sys.stdout.buffer.write(b"\r\n")
    sys.stdout.buffer.write(data)


def _log_sanitizer():
    """Build a (text) -> text function that scrubs account-identifying data.

    We ship this ZIP to support requests / GitHub issues, so anything that
    leaks the user's Apple ID, account UUID, or session tokens is a privacy
    bug. The scrubber runs per-line and keeps a stable alias (apple-id-1,
    account-1) so multi-account logs remain correlatable after redaction.
    """
    import re
    import config_manager

    email_aliases = {}
    account_aliases = {}

    # Preload known account IDs + Apple IDs from config so redaction is
    # consistent even if they don't happen to appear in this particular
    # log file (and to keep numbering stable across multiple exports).
    try:
        cfg = config_manager.load_config() or {}
        for i, acc in enumerate(cfg.get("accounts") or [], 1):
            apple_id = (acc.get("apple_id") or "").strip().lower()
            if apple_id:
                email_aliases[apple_id] = "<apple-id-%d>" % i
            account_id = acc.get("id") or ""
            if account_id:
                account_aliases[account_id] = "<account-%d>" % i
    except Exception:
        pass

    email_re = re.compile(r"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}")
    uuid_re = re.compile(r"\b[0-9a-fA-F]{8}\b")  # 8-hex account-id prefix style
    # Catch auth-sensitive key=value chunks on a single line. We look for the
    # key name and nuke the rest of the token up to whitespace / quote / comma.
    secret_kv_re = re.compile(
        r"(?i)(password|passwd|pwd|token|cookie|authorization|x-apple-[\w-]*|"
        r"session[_-]?id|trust[_-]?token|srp[_-]?[a-z]*|apple[_-]?id[_-]?(?:\w*))"
        r"\s*[:=]\s*['\"]?([^\s,'\")}]+)",
    )
    # Authorization-style header values: "Bearer <tok>".
    bearer_re = re.compile(r"(?i)\bBearer\s+\S+")

    def alias_email(match):
        addr = match.group(0).lower()
        if addr not in email_aliases:
            email_aliases[addr] = "<apple-id-%d>" % (len(email_aliases) + 1)
        return email_aliases[addr]

    def alias_uuid(match):
        uuid = match.group(0)
        # Don't alias short hex chunks that are unlikely to be account ids —
        # timestamps / log levels like "INFO" aren't hex anyway. We only
        # redact values that appear in known_account_ids; unrecognised hex
        # (git SHAs, request IDs) is safe to leave alone.
        if uuid in account_aliases:
            return account_aliases[uuid]
        return uuid

    def sanitize(text):
        text = email_re.sub(alias_email, text)
        text = uuid_re.sub(alias_uuid, text)
        text = secret_kv_re.sub(lambda m: "%s=<redacted>" % m.group(1), text)
        text = bearer_re.sub("Bearer <redacted>", text)
        return text

    return sanitize


def export_logs_zip():
    """Stream all package logs + INFO + version as a ZIP for support reports.

    Used by the "Export logs" button in the Logs tab. Every text file is
    passed through a sanitizer that strips Apple IDs, account UUIDs, and
    auth-shaped key=value tokens before it lands in the ZIP. We never
    include config.json or session cookie files.
    """
    import zipfile
    import io
    import time as _time
    import config_manager

    log_dir = os.path.join(config_manager.PKG_VAR, "logs")
    pkg_dir = "/var/packages/iCloudPhotoSync"
    sanitize = _log_sanitizer()

    def _sanitize_and_add(zf, src_path, arcname):
        try:
            with open(src_path, "r", errors="replace") as f:
                content = sanitize(f.read())
        except OSError:
            return
        zf.writestr(arcname, content)

    buf = io.BytesIO()
    with zipfile.ZipFile(buf, "w", zipfile.ZIP_DEFLATED) as zf:
        # Every file in var/logs/ (sync.log, scheduler.log, cron.log,
        # startup-error.log, etc.). We read as text and sanitize — any
        # binary artifact in logs/ (shouldn't exist, but just in case) is
        # skipped by the errors="replace" read.
        if os.path.isdir(log_dir):
            for name in sorted(os.listdir(log_dir)):
                path = os.path.join(log_dir, name)
                if os.path.isfile(path):
                    _sanitize_and_add(zf, path, "logs/" + name)

        # INFO is the pkg metadata (version, maintainer). It doesn't contain
        # user data, but run it through the sanitizer anyway for defence in
        # depth (the maintainer email is there but that's public).
        info = os.path.join(pkg_dir, "INFO")
        if os.path.isfile(info):
            _sanitize_and_add(zf, info, "INFO")

        # A small environment snapshot so a support report has DSM version,
        # architecture, and the detected Python path in one place. We
        # explicitly do NOT include serial numbers from /proc/cpuinfo —
        # ARM-j boards sometimes expose the NAS serial there.
        try:
            lines = []
            lines.append("timestamp: %s" % _time.strftime("%Y-%m-%d %H:%M:%S"))
            lines.append("python: %s" % sys.version.replace("\n", " "))
            lines.append("platform: %s" % sys.platform)
            try:
                import platform as _p
                lines.append("machine: %s" % _p.machine())
                lines.append("system: %s %s" % (_p.system(), _p.release()))
            except Exception:
                pass
            try:
                with open("/etc.defaults/VERSION", "r") as f:
                    lines.append("---- /etc.defaults/VERSION ----")
                    for ln in f.read().splitlines():
                        # unique= and upnpmodelname= contain NAS-identifying
                        # values; strip them. Everything else (majorversion,
                        # build, etc.) is useful for debugging.
                        low = ln.lower()
                        if low.startswith("unique=") or "upnp" in low or \
                           "serial" in low or "mac" in low:
                            continue
                        lines.append(ln)
            except OSError:
                pass
            try:
                with open("/proc/cpuinfo", "r") as f:
                    lines.append("---- /proc/cpuinfo (architecture only) ----")
                    for ln in f.read().splitlines():
                        low = ln.lower()
                        # Keep arch/feature info; drop serial / hardware IDs.
                        if low.startswith(("serial", "hardware", "revision")):
                            continue
                        lines.append(ln)
                        if len(lines) > 400:
                            break
            except OSError:
                pass
            zf.writestr("environment.txt", "\n".join(lines))
        except Exception:
            pass

        # Also include a one-line note that the archive was sanitized so
        # anyone receiving it knows Apple IDs are aliases, not the originals.
        zf.writestr(
            "README.txt",
            "iCloud Photo Sync support bundle\n"
            "Generated: %s\n\n"
            "Email addresses (Apple IDs) have been replaced with aliases\n"
            "like <apple-id-1>. Account UUIDs, auth tokens, passwords, and\n"
            "trust cookies have been redacted. config.json and session\n"
            "cookie files are never included in this archive.\n" %
            _time.strftime("%Y-%m-%d %H:%M:%S"),
        )

    data = buf.getvalue()
    zipname = "iCloudPhotoSync-logs-%s.zip" % _time.strftime("%Y%m%d-%H%M%S")
    sys.stdout.buffer.write(b"Content-Type: application/zip\r\n")
    sys.stdout.buffer.write(("Content-Length: %d\r\n" % len(data)).encode())
    sys.stdout.buffer.write(
        ('Content-Disposition: attachment; filename="%s"\r\n' % zipname).encode()
    )
    sys.stdout.buffer.write(b"\r\n")
    sys.stdout.buffer.write(data)


def _method_from_query():
    """Parse the 'method' value from QUERY_STRING without touching stdin."""
    qs = os.environ.get("QUERY_STRING", "")
    parsed = urllib.parse.parse_qs(qs)
    vals = parsed.get("method", [])
    return vals[0] if vals else ""


def main():
    # Read the method from QUERY_STRING first so POST bodies (download_zip)
    # aren't accidentally consumed by cgi.FieldStorage before the handler runs.
    method = _method_from_query()

    if method == "thumb":
        proxy_thumb()
        return
    if method == "download":
        download_photo()
        return
    if method == "download_zip":
        length = int(os.environ.get("CONTENT_LENGTH", "0") or 0)
        raw_body = sys.stdin.read(length) if length else ""
        download_zip(raw_body)
        return
    if method == "log_export":
        export_logs_zip()
        return

    params = cgi.FieldStorage()

    # POST requests put params (incl. method) in the body, not QUERY_STRING.
    if not method:
        method = params.getvalue("method", "") or ""

    handler = HANDLERS.get(method)

    if not handler:
        respond(False, error={"code": 100, "message": "Unknown method: %s" % method})
        return

    try:
        result = handler(params)
        respond(**result)
    except Exception as e:
        respond(False, error={"code": 500, "message": str(e)})


if __name__ == "__main__":
    main()
