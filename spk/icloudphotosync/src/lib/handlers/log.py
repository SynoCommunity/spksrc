"""
Log Handler — read sync log entries.

Actions:
  list   — Get recent log lines (default last 200)
  clear  — Clear the log file
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.realpath(__file__))))

import config_manager


def handle(params):
    action = params.getvalue("action", "list")

    if action == "list":
        return _list_logs(params)
    if action == "clear":
        return _clear_logs(params)
    if action == "get_level":
        return _get_level(params)
    if action == "set_level":
        return _set_level(params)

    return {"success": False, "error": {"code": 101, "message": "Unknown action"}}


def _parse_log_lines(log_dir):
    """Read and parse all log files into structured records."""
    log_files = ["sync.log", "cron.log"]
    records = []

    for lf in log_files:
        path = os.path.join(log_dir, lf)
        if not os.path.isfile(path):
            continue
        try:
            with open(path, "r", errors="replace") as f:
                for line in f:
                    line = line.strip()
                    if not line:
                        continue

                    level = "info"
                    timestamp = ""
                    message = line

                    # Parse: "2026-04-11 19:50:40 [INFO] module: message"
                    import re
                    m = re.match(r"^(\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}:\d{2})\s+\[(\w+)\]\s+\S+:\s*(.*)", line)
                    if m:
                        timestamp = m.group(1)
                        level = m.group(2).lower()
                        message = m.group(3)
                    else:
                        m2 = re.match(r"^(\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}:\d{2})\s+(.*)", line)
                        if m2:
                            timestamp = m2.group(1)
                            message = m2.group(2)
                        if "error" in line.lower():
                            level = "error"
                        elif "warn" in line.lower():
                            level = "warning"

                    records.append({
                        "level": level,
                        "timestamp": timestamp,
                        "message": message
                    })
        except Exception:
            continue

    # Newest first
    records.reverse()
    return records


_LEVEL_RANK = {"debug": 0, "info": 1, "warning": 2, "error": 3}


def _list_logs(params):
    # Ext JS PagingToolbar sends "start" and "limit"
    try:
        offset = int(params.getvalue("start", "0"))
    except (ValueError, TypeError):
        offset = 0
    try:
        limit = min(int(params.getvalue("limit", "50")), 1000)
    except (ValueError, TypeError):
        limit = 50
    min_level = params.getvalue("level", "").strip().lower()

    log_dir = os.path.join(config_manager.PKG_VAR, "logs")
    all_records = _parse_log_lines(log_dir)

    if min_level in _LEVEL_RANK:
        threshold = _LEVEL_RANK[min_level]
        all_records = [
            r for r in all_records
            if _LEVEL_RANK.get(r.get("level", "info"), 1) >= threshold
        ]

    total = len(all_records)
    page = all_records[offset:offset + limit]

    return {
        "success": True,
        "total": total,
        "data": page
    }


def _clear_logs(params):
    log_dir = os.path.join(config_manager.PKG_VAR, "logs")
    for lf in ["sync.log", "cron.log"]:
        path = os.path.join(log_dir, lf)
        try:
            with open(path, "w") as f:
                f.write("")
        except Exception:
            pass

    return {"success": True, "data": {"message": "Logs cleared"}}


def _get_level(params):
    cfg = config_manager.load_config()
    return {"success": True, "data": {"level": cfg.get("log_level", "INFO")}}


def _set_level(params):
    level = params.getvalue("level", "").strip().upper()
    if level not in ("DEBUG", "INFO", "WARNING", "ERROR"):
        return {"success": False, "error": {"code": 401, "message": "Invalid level"}}
    cfg = config_manager.load_config()
    cfg["log_level"] = level
    config_manager.save_config(cfg)
    return {"success": True, "data": {"level": level}}
