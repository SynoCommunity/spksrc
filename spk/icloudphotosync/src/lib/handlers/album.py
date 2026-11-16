"""
Album Handler — list albums, get photos, thumbnails.

Actions:
  list    — Get all albums (names + cached counts)
  count   — Get photo count for a single album (+ update cache)
  photos  — Get photos in an album (paginated)
"""
import json
import logging
import sys
import os
import time
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.realpath(__file__))))

import config_manager
import icloud_client

logger = logging.getLogger(__name__)

ADP_ERROR_CODE = 320

_TYPE_ORDER = {"all": 0, "folder": 1, "user": 1, "smart": 2, "shared": 3}


def _album_sort_key(a):
    """Sort: All Photos first, then user+folder albums grouped (folders
    before their children, sub-albums directly beneath their parent),
    then smart folders, then shared."""
    t = _TYPE_ORDER.get(a["type"], 9)
    parent = a.get("parent_folder") or ""
    group = (parent or a["name"]).lower()
    is_child = 1 if parent else 0
    return (t, group, is_child, a["name"].lower())


def _maybe_adp_error(exc, fallback_code):
    """Return an ADP-specific error response when appropriate."""
    from pyicloud_ipd.exceptions import (
        PyiCloudADPProtectionException,
        PyiCloudServiceNotActivatedException,
    )
    if isinstance(exc, PyiCloudADPProtectionException):
        return {"success": False, "error": {"code": ADP_ERROR_CODE, "message": str(exc)}}
    if isinstance(exc, PyiCloudServiceNotActivatedException):
        return {"success": False, "error": {"code": ADP_ERROR_CODE, "message":
            "iCloud Photos is not available for this account. "
            "Make sure iCloud Photos is enabled in the Apple ID settings."}}
    return {"success": False, "error": {"code": fallback_code, "message": str(exc)}}


def _cache_path(account_id):
    return os.path.join(config_manager.get_account_dir(account_id), "album_cache.json")


def _load_cache(account_id):
    try:
        with open(_cache_path(account_id), "r") as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return {"counts": {}, "updated": 0}


def _save_cache(account_id, cache):
    cache["updated"] = int(time.time())
    try:
        with open(_cache_path(account_id), "w") as f:
            json.dump(cache, f)
    except Exception:
        pass


def handle(params):
    action = params.getvalue("action", "")

    if action == "list":
        return _list_albums(params)
    if action == "count":
        return _album_count(params)
    if action == "photos":
        return _list_photos(params)
    if action == "cached":
        return _cached_albums(params)

    return {"success": False, "error": {"code": 101, "message": "Unknown action"}}


def _cached_albums(params):
    """Return album data from local cache only — no Apple API calls."""
    account_id = params.getvalue("account_id", "").strip()
    if not account_id:
        return {"success": False, "error": {"code": 301, "message": "account_id required"}}

    cache = _load_cache(account_id)
    counts = cache.get("counts", {})
    if not counts:
        return {"success": True, "data": {"albums": [], "from_cache": True, "cache_age": -1}}

    album_list = []
    album_types = cache.get("types", {})
    cached_parents = cache.get("parents", {})
    for name, count in counts.items():
        cached_type = album_types.get(name)
        if cached_type:
            atype = cached_type
        elif name in ("All Photos",):
            atype = "all"
        elif any(name == s for s in ("Favorites", "Videos", "Screenshots", "Live",
                                      "Panoramas", "Time-lapse", "Slo-mo", "Bursts")):
            atype = "smart"
        else:
            atype = "user"
        album_list.append({
            "name": name, "type": atype, "photo_count": count,
            "parent_folder": cached_parents.get(name),
        })

    album_list.sort(key=_album_sort_key)

    cache_age = int(time.time()) - cache.get("updated", 0)
    return {"success": True, "data": {"albums": album_list, "from_cache": True, "cache_age": cache_age}}


def _get_authenticated_client(params):
    """Helper: get an authenticated icloud client from account_id param."""
    account_id = params.getvalue("account_id", "").strip()
    if not account_id:
        return None, {"success": False, "error": {"code": 301, "message": "account_id required"}}

    account = config_manager.get_account(account_id)
    if not account:
        return None, {"success": False, "error": {"code": 302, "message": "Account not found"}}

    client = icloud_client.get_client(account_id, account["apple_id"])
    if not client.restore_session():
        return None, {"success": False, "error": {"code": 303, "message": "Not authenticated"}}

    return client, None


def _list_albums(params):
    client, err = _get_authenticated_client(params)
    if err:
        return err

    account_id = params.getvalue("account_id", "").strip()
    cache = _load_cache(account_id)
    cached_counts = cache.get("counts", {})

    try:
        photos_svc = client.api.photos
        albums = photos_svc.albums

        album_list = []
        cached_parents = {}
        for name, album in albums.items():
            parent = getattr(album, "parent_folder", None)
            if parent:
                cached_parents[name] = parent
            album_list.append({
                "name": name,
                "type": album.album_type,
                "photo_count": cached_counts.get(name, -1),
                "parent_folder": parent,
            })

        # Shared albums
        try:
            shared = photos_svc.shared_albums
            for name, album in shared.items():
                album_list.append({
                    "name": name,
                    "type": "shared",
                    "photo_count": cached_counts.get(name, -1),
                })
        except Exception:
            logger.warning("Failed to list shared albums", exc_info=True)

        # Shared Library (iOS 16+ family sharing — separate from shared albums)
        has_shared_library = False
        try:
            has_shared_library = photos_svc.has_shared_library
        except Exception:
            pass

        # Persist parent relationships and shared library status in cache
        cache["has_shared_library"] = has_shared_library
        if cached_parents:
            cache["parents"] = cached_parents
        _save_cache(account_id, cache)

        album_list.sort(key=_album_sort_key)

        cache_age = int(time.time()) - cache.get("updated", 0)
        return {"success": True, "data": {
            "albums": album_list,
            "cache_age": cache_age,
            "has_shared_library": has_shared_library,
        }}

    except Exception as e:
        return _maybe_adp_error(e, 310)


def _album_count(params):
    client, err = _get_authenticated_client(params)
    if err:
        return err

    account_id = params.getvalue("account_id", "").strip()
    album_name = params.getvalue("album", "").strip()
    if not album_name:
        return {"success": False, "error": {"code": 311, "message": "album required"}}

    try:
        photos_svc = client.api.photos
        album = photos_svc.albums.get(album_name)
        if not album:
            album = photos_svc.shared_albums.get(album_name)
        if not album:
            return {"success": False, "error": {"code": 311, "message": "Album not found"}}

        if album.album_type == "folder":
            count = 0
        else:
            count = album.photo_count

        # Update cache
        cache = _load_cache(account_id)
        cache.setdefault("counts", {})[album_name] = count
        cache.setdefault("types", {})[album_name] = album.album_type
        _save_cache(account_id, cache)

        return {"success": True, "data": {"album": album_name, "photo_count": count}}

    except Exception as e:
        return _maybe_adp_error(e, 312)


def _list_photos(params):
    client, err = _get_authenticated_client(params)
    if err:
        return err

    album_name = params.getvalue("album", "All Photos").strip()
    limit = int(params.getvalue("limit", "50"))
    offset = int(params.getvalue("offset", "0"))
    direction = params.getvalue("direction", "ASCENDING").strip().upper()
    if direction not in ("ASCENDING", "DESCENDING"):
        direction = "ASCENDING"

    try:
        photos_svc = client.api.photos
        album = photos_svc.albums.get(album_name)
        if not album:
            album = photos_svc.shared_albums.get(album_name)

        if not album:
            return {"success": False, "error": {"code": 311, "message": "Album not found"}}

        photos = album.photos(limit=limit, offset=offset, direction=direction)
        photo_list = [p.to_dict() for p in photos]

        return {
            "success": True,
            "data": {
                "album": album_name,
                "photos": photo_list,
                "offset": offset,
                "direction": direction,
                "count": len(photo_list),
                "total": album.photo_count or 0,
            }
        }

    except Exception as e:
        return {"success": False, "error": {"code": 312, "message": str(e)}}
