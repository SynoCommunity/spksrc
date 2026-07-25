import sys
import os
import time

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.realpath(__file__))))
import config_manager


def _read_pkg_version():
    info_path = "/var/packages/iCloudPhotoSync/INFO"
    try:
        with open(info_path, "r") as f:
            for line in f:
                if line.startswith("version="):
                    return line.split("=", 1)[1].strip().strip('"')
    except (OSError, IOError):
        pass
    return "unknown"


_PKG_VERSION = _read_pkg_version()


def handle(params):
    action = params.getvalue("action", "get")

    if action == "get":
        accounts = config_manager.get_accounts()
        return {
            "success": True,
            "data": {
                "running": True,
                "sync_status": "idle",
                "accounts": len(accounts),
                "next_sync": None,
                "version": _PKG_VERSION,
                "timestamp": int(time.time()),
            },
        }

    return {"success": False, "error": {"code": 101, "message": "Unknown action"}}
