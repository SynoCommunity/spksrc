"""
HEIC Converter — converts HEIC/HEIF images to JPG.

Fallback chain (in order):
  1. Cross-compiled heif-convert    (installed to bin/ via spksrc cross/heif-convert)
  2. SynoCommunity imagemagick SPK  (/var/packages/imagemagick/target/bin/convert)
  3. Synology CodecPack / AME       (/var/packages/CodecPack/target/usr/bin/convert)
  4. System `convert` on PATH
  5. Pillow + pillow-heif           (only if vendored — Py 3.10+ and not default)
"""
import logging
import os
import shutil
import subprocess

LOGGER = logging.getLogger("heic_converter")

_PKG_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def _probe_cross_compiled_heif():
    """Check for heif-convert installed by spksrc cross-compilation."""
    binary = os.path.join(_PKG_ROOT, "bin", "heif-convert")
    lib_dir = os.path.join(_PKG_ROOT, "lib")
    plugin_dir = os.path.join(lib_dir, "libheif", "plugins")
    if os.path.isfile(binary) and not os.access(binary, os.X_OK):
        try:
            os.chmod(binary, 0o755)
        except OSError:
            pass
    if os.path.isfile(binary) and os.access(binary, os.X_OK):
        return {
            "cmd": "heif-convert",
            "binary": binary,
            "lib_dir": lib_dir if os.path.isdir(lib_dir) else None,
            "plugin_dir": plugin_dir if os.path.isdir(plugin_dir) else None,
            "source": "cross-compiled",
        }
    return None


def _probe_magick(path, source):
    if os.path.isfile(path) and os.access(path, os.X_OK):
        lib = os.path.join(os.path.dirname(os.path.dirname(path)), "lib")
        return {
            "cmd": "convert",
            "binary": path,
            "lib_dir": lib if os.path.isdir(lib) else None,
            "plugin_dir": None,
            "source": source,
        }
    return None


def _probe_backends():
    b = _probe_cross_compiled_heif()
    if b:
        return b
    b = _probe_magick("/var/packages/imagemagick/target/bin/convert", "synocommunity")
    if b:
        return b
    b = _probe_magick("/var/packages/CodecPack/target/usr/bin/convert", "codecpack")
    if b:
        return b
    p = shutil.which("convert")
    if p:
        try:
            r = subprocess.run([p, "-list", "delegate"], capture_output=True, text=True, timeout=5)
            if "heif" not in r.stdout.lower() and "heic" not in r.stdout.lower():
                LOGGER.info("System convert at %s has no HEIC delegate, skipping", p)
                return None
        except Exception:
            pass
        return {"cmd": "convert", "binary": p, "lib_dir": None, "plugin_dir": None, "source": "system"}
    return None


_BACKEND = _probe_backends()
_PILLOW_OK = False
try:
    from PIL import Image  # noqa: F401
    import pillow_heif
    pillow_heif.register_heif_opener()
    _PILLOW_OK = True
except Exception:
    _PILLOW_OK = False

if _BACKEND and _PILLOW_OK:
    LOGGER.info("HEIC converter: %s (%s) at %s, Pillow fallback available",
                _BACKEND["cmd"], _BACKEND["source"], _BACKEND["binary"])
elif _BACKEND:
    LOGGER.info("HEIC converter: %s (%s) at %s", _BACKEND["cmd"], _BACKEND["source"], _BACKEND["binary"])
elif _PILLOW_OK:
    LOGGER.info("HEIC converter: Pillow + pillow-heif")
else:
    LOGGER.warning("HEIC converter: no backend available — HEIC files will stay as HEIC")


def backend_info():
    """Return a dict describing the active backend, for UI/status pages."""
    if _BACKEND:
        return {
            "available": True,
            "backend": _BACKEND["cmd"],
            "source": _BACKEND["source"],
            "binary": _BACKEND["binary"],
        }
    if _PILLOW_OK:
        return {"available": True, "backend": "pillow", "source": "vendored", "binary": None}
    return {"available": False, "backend": None, "source": None, "binary": None}


def is_heic(filename):
    ext = os.path.splitext(filename)[1].lower()
    return ext in (".heic", ".heif")


def can_convert():
    return _BACKEND is not None or _PILLOW_OK


def convert_to_jpg(heic_path, jpg_path=None, quality=85):
    """Convert HEIC to JPG. Returns output path on success, None on failure."""
    if not can_convert():
        return None

    if jpg_path is None:
        jpg_path = os.path.splitext(heic_path)[0] + ".jpg"

    if _BACKEND:
        result = _convert_cli(heic_path, jpg_path, quality)
        if result:
            return result
        if _PILLOW_OK:
            LOGGER.info("CLI backend failed, falling back to Pillow for %s", heic_path)
            return _convert_pillow(heic_path, jpg_path, quality)
        return None
    if _PILLOW_OK:
        return _convert_pillow(heic_path, jpg_path, quality)
    return None


def _convert_cli(heic_path, jpg_path, quality):
    env = os.environ.copy()
    if _BACKEND.get("lib_dir"):
        existing = env.get("LD_LIBRARY_PATH", "")
        env["LD_LIBRARY_PATH"] = _BACKEND["lib_dir"] + (":" + existing if existing else "")
    if _BACKEND.get("plugin_dir"):
        env["LIBHEIF_PLUGIN_PATH"] = _BACKEND["plugin_dir"]

    if _BACKEND["cmd"] == "heif-convert":
        # heif-convert syntax: heif-convert [-q N] input output
        cmd = [_BACKEND["binary"], "-q", str(quality), heic_path, jpg_path]
    else:
        # ImageMagick convert syntax: convert input -quality N output
        cmd = [_BACKEND["binary"], heic_path, "-quality", str(quality), jpg_path]

    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=180, env=env)
        if result.returncode == 0 and os.path.isfile(jpg_path):
            try:
                os.chmod(jpg_path, 0o644)
            except OSError:
                pass
            LOGGER.info("Converted %s -> %s (%s/%s)", heic_path, jpg_path,
                        _BACKEND["cmd"], _BACKEND["source"])
            return jpg_path
        LOGGER.error("%s failed for %s: %s", _BACKEND["cmd"], heic_path, (result.stderr or "").strip())
        return None
    except subprocess.TimeoutExpired:
        LOGGER.error("%s timed out for %s", _BACKEND["cmd"], heic_path)
        return None
    except Exception as e:
        LOGGER.error("%s error for %s: %s", _BACKEND["cmd"], heic_path, e)
        return None


def _convert_pillow(heic_path, jpg_path, quality):
    try:
        from PIL import Image
        img = Image.open(heic_path)
        exif = img.info.get("exif", b"")
        if exif:
            img.save(jpg_path, "JPEG", quality=quality, exif=exif)
        else:
            img.save(jpg_path, "JPEG", quality=quality)
        try:
            os.chmod(jpg_path, 0o644)
        except OSError:
            pass
        LOGGER.info("Converted %s -> %s (Pillow)", heic_path, jpg_path)
        return jpg_path
    except Exception as e:
        LOGGER.error("Pillow conversion failed for %s: %s", heic_path, e)
        return None
