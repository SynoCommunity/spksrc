"""PhotosService — iCloud Photos via CloudKit API."""
import base64
import json
import logging
import time

LOGGER = logging.getLogger(__name__)

# Smart album filter values: (query_filter for photos, count_key for HyperionIndexCountLookup)
# Apple uses UPPERCASE for photo queries but mixed-case for count queries
SMART_FOLDERS = {
    "Favorites": ("FAVORITE", "Favorite"),
    "Videos": ("VIDEO", "Video"),
    "Screenshots": ("SCREENSHOT", "Screenshot"),
    "Live": ("LIVE", "Live"),
    "Panoramas": ("PANORAMA", "Panorama"),
    "Time-lapse": ("TIME-LAPSE", "Time-lapse"),
    "Slo-mo": ("SLO-MO", "Slo-mo"),
    "Bursts": ("BURST", "Burst"),
}


class PhotoAlbum:
    """Represents an iCloud Photos album."""

    def __init__(self, service, name, record_name=None, album_type="user",
                 smart_filter=None, smart_count_key=None,
                 list_type=None, obj_type=None, zone_id=None,
                 parent_folder=None):
        self.service = service
        self.name = name
        self.record_name = record_name
        self.album_type = album_type  # "all", "user", "smart", "shared", "folder"
        self.smart_filter = smart_filter
        self._photo_count = None
        self.zone_id = zone_id
        self.parent_folder = parent_folder

        if album_type == "all":
            self.list_type = "CPLAssetAndMasterByAssetDateWithoutHiddenOrDeleted"
            self.obj_type = "CPLAssetByAssetDateWithoutHiddenOrDeleted"
        elif album_type == "smart":
            self.list_type = "CPLAssetAndMasterInSmartAlbumByAssetDate"
            self.obj_type = "CPLAssetInSmartAlbumByAssetDate:%s" % (smart_count_key or smart_filter)
        elif album_type == "user":
            self.list_type = "CPLContainerRelationLiveByAssetDate"
            self.obj_type = "CPLContainerRelationNotDeletedByAssetDate:%s" % record_name
        elif album_type == "shared":
            self.list_type = "CPLAssetAndMasterByAssetDateWithoutHiddenOrDeleted"
            self.obj_type = "CPLAssetByAssetDateWithoutHiddenOrDeleted"
        else:
            self.list_type = list_type
            self.obj_type = obj_type

    @property
    def _is_shared_library(self):
        return (self.zone_id or {}).get("zoneName", "").startswith("SharedSync-")

    @property
    def photo_count(self):
        if self._photo_count is None:
            if self.album_type == "folder":
                self._photo_count = 0
            elif self._is_shared_library:
                self._photo_count = self.service._get_shared_library_count()
            elif self.album_type == "shared":
                self._photo_count = self.service._get_shared_album_count(self)
            else:
                self._photo_count = self.service._get_album_count(self.obj_type)
        return self._photo_count

    def photos(self, limit=200, offset=0, direction="ASCENDING"):
        """Fetch photos in this album."""
        if self._is_shared_library:
            return self.service.get_shared_library_photos(limit=limit, offset=offset, direction=direction)
        if self.album_type == "shared":
            return self.service._get_shared_album_photos(self, limit=limit, offset=offset, direction=direction)
        return self.service._get_album_photos(self, limit=limit, offset=offset, direction=direction)

    def __repr__(self):
        return "<PhotoAlbum: %s>" % self.name


class PhotoAsset:
    """Represents a single photo/video asset."""

    def __init__(self, master_record, asset_record=None):
        self._master = master_record
        self._asset = asset_record
        self._parse()

    def _parse(self):
        m = self._master.get("fields", {})
        a = self._asset.get("fields", {}) if self._asset else {}

        # Filename
        raw = m.get("filenameEnc", {}).get("value", "")
        try:
            self.filename = base64.b64decode(raw).decode("utf-8")
        except Exception:
            self.filename = raw

        # Dates
        self.created = a.get("assetDate", {}).get("value", 0)
        self.added = a.get("addedDate", {}).get("value", 0)

        # Type
        self.item_type = m.get("itemType", {}).get("value", "public.jpeg")
        self.is_video = "movie" in self.item_type or "video" in self.item_type

        # Dimensions
        self.width = m.get("resOriginalWidth", {}).get("value", 0)
        self.height = m.get("resOriginalHeight", {}).get("value", 0)

        # Size and checksum from original resource
        res = m.get("resOriginalRes", {}).get("value", {})
        self.size = res.get("size", 0)
        self.checksum = res.get("fileChecksum", "")

        # Record name for identification
        self.id = self._master.get("recordName", "")

    @staticmethod
    def _fix_url(url):
        """Replace ${f} placeholder in iCloud download URLs."""
        if url and "${f}" in url:
            return url.replace("${f}", "image.jpg")
        return url

    @property
    def thumb_url(self):
        """URL for JPEG thumbnail."""
        m = self._master.get("fields", {})
        thumb = m.get("resJPEGThumbRes", {}).get("value", {})
        return self._fix_url(thumb.get("downloadURL"))

    @property
    def medium_url(self):
        """URL for medium JPEG."""
        m = self._master.get("fields", {})
        med = m.get("resJPEGMedRes", {}).get("value", {})
        return self._fix_url(med.get("downloadURL"))

    @property
    def original_url(self):
        """URL for original file."""
        m = self._master.get("fields", {})
        orig = m.get("resOriginalRes", {}).get("value", {})
        return self._fix_url(orig.get("downloadURL"))

    def to_dict(self):
        """Serializable dict for JSON responses."""
        return {
            "id": self.id,
            "filename": self.filename,
            "created": self.created,
            "item_type": self.item_type,
            "is_video": self.is_video,
            "width": self.width,
            "height": self.height,
            "size": self.size,
            "checksum": self.checksum,
            "thumb_url": self.thumb_url,
            "medium_url": self.medium_url,
            "original_url": self.original_url,
        }

    def __repr__(self):
        return "<PhotoAsset: %s>" % self.filename


class PhotosService:
    """iCloud Photos service via CloudKit API."""

    ZONE_ID = {"zoneName": "PrimarySync"}

    def __init__(self, service_root, session, params):
        self.session = session
        self.params = dict(params)
        self.params.update({
            "remapEnums": "true",
            "getCurrentSyncToken": "true",
        })
        self._service_root = service_root
        self._service_endpoint = (
            "%s/database/1/com.apple.photos.cloud/production/private"
            % service_root
        )
        self._shared_endpoint = (
            "%s/database/1/com.apple.photos.cloud/production/shared"
            % service_root
        )
        self._albums = None
        self._shared_albums = None
        self._shared_library = None
        self._shared_library_zone = None

    def _query(self, payload):
        """Execute a CloudKit records query."""
        url = "%s/records/query" % self._service_endpoint
        response = self.session.post(
            url,
            params=self.params,
            data=json.dumps(payload),
            headers={"Content-Type": "text/plain"},
        )
        data = response.json()
        self._check_cloudkit_adp(data)
        return data

    def _lookup_records(self, record_names, zone_id=None):
        """Fetch records by recordName via CloudKit records/lookup."""
        url = "%s/records/lookup" % self._service_endpoint
        zid = zone_id or self.ZONE_ID
        payload = {
            "records": [
                {"recordName": rn, "zoneID": zid}
                for rn in record_names
            ],
        }
        response = self.session.post(
            url,
            params=self.params,
            data=json.dumps(payload),
            headers={"Content-Type": "text/plain"},
        )
        data = response.json()
        self._check_cloudkit_adp(data)
        return data

    def refresh_photo_url(self, photo, zone_id=None):
        """Re-fetch a photo's master record to get fresh download URLs.

        Retries with exponential backoff for transient/server errors.
        Returns a new URL or None if the lookup fails.
        """
        for attempt in range(3):
            try:
                data = self._lookup_records([photo.id], zone_id=zone_id)
                found = False
                server_error = False
                for record in data.get("records", []):
                    if record.get("recordName") != photo.id:
                        continue
                    found = True
                    if record.get("serverErrorCode"):
                        server_error = True
                        LOGGER.warning("Refresh got serverError %s for %s",
                                       record["serverErrorCode"], photo.id)
                        break
                    orig = record.get("fields", {}).get(
                        "resOriginalRes", {}).get("value", {})
                    url = orig.get("downloadURL")
                    if url:
                        photo._master = record
                        return PhotoAsset._fix_url(url)
                if found and not server_error:
                    return None
            except Exception:
                LOGGER.debug("Refresh attempt %d failed for %s",
                             attempt + 1, photo.id)
            if attempt < 2:
                time.sleep(1 + attempt * 2)
        LOGGER.error("Failed to refresh URL for %s after %d attempts",
                     photo.id, 3)
        return None

    def batch_refresh_photo_urls(self, photos, zone_id=None):
        """Re-fetch master records for multiple photos to get fresh URLs.

        Returns dict of photo.id -> fresh_url for successfully refreshed
        photos. Raises on session/auth errors so the caller can re-auth.
        """
        if not photos:
            return {}
        record_names = [p.id for p in photos]
        data = self._lookup_records(record_names, zone_id=zone_id)
        photo_map = {p.id: p for p in photos}
        result = {}
        for record in data.get("records", []):
            rn = record.get("recordName", "")
            if rn not in photo_map or record.get("serverErrorCode"):
                continue
            orig = record.get("fields", {}).get(
                "resOriginalRes", {}).get("value", {})
            url = orig.get("downloadURL")
            if url:
                photo_map[rn]._master = record
                result[rn] = PhotoAsset._fix_url(url)
        return result

    def _batch_query(self, payload):
        """Execute a CloudKit batch query."""
        url = "%s/internal/records/query/batch" % self._service_endpoint
        response = self.session.post(
            url,
            params=self.params,
            data=json.dumps(payload),
            headers={"Content-Type": "text/plain"},
        )
        data = response.json()
        self._check_cloudkit_adp(data)
        return data

    @staticmethod
    def _check_cloudkit_adp(data):
        """Detect CloudKit errors that indicate ADP is blocking access."""
        from pyicloud_ipd.exceptions import PyiCloudADPProtectionException
        if not isinstance(data, dict):
            return
        for record in data.get("records", []):
            reason = record.get("serverErrorCode", "")
            if reason in ("ACCESS_DENIED", "PRIVATE_DB_DISABLED",
                          "ZONE_NOT_FOUND"):
                raise PyiCloudADPProtectionException(reason)

    def check_indexing(self):
        """Check if Photos library indexing is complete."""
        data = self._query({
            "query": {"recordType": "CheckIndexingState"},
            "zoneID": self.ZONE_ID,
        })
        records = data.get("records", [])
        if records:
            state = records[0].get("fields", {}).get("state", {}).get("value")
            return state == "FINISHED"
        return False

    @property
    def albums(self):
        """Returns dict of album name -> PhotoAlbum."""
        if self._albums is not None:
            return self._albums

        self._albums = {}

        # "All Photos" built-in
        self._albums["All Photos"] = PhotoAlbum(
            self, "All Photos", album_type="all"
        )

        # Smart folders
        for name, (query_filter, count_key) in SMART_FOLDERS.items():
            self._albums[name] = PhotoAlbum(
                self, name, album_type="smart",
                smart_filter=query_filter, smart_count_key=count_key,
            )

        # User-created albums (top-level; sub-albums inside folders are
        # fetched in a second pass below).
        folders = {}  # recordName -> folder name
        try:
            data = self._query({
                "query": {"recordType": "CPLAlbumByPositionLive"},
                "zoneID": self.ZONE_ID,
                "resultsLimit": 500,
            })
            for record in data.get("records", []):
                rn = record.get("recordName", "")
                if rn in ("----Root-Folder----", "----Project-Root-Folder----"):
                    continue
                fields = record.get("fields", {})
                if fields.get("isDeleted", {}).get("value"):
                    continue
                raw_name = fields.get("albumNameEnc", {}).get("value", "")
                name = ""
                if raw_name:
                    try:
                        name = base64.b64decode(raw_name).decode("utf-8")
                    except Exception:
                        name = raw_name
                if not name:
                    name = fields.get("albumName", {}).get("value", "")
                if not name:
                    continue
                is_folder = fields.get("albumType", {}).get("value", 0) == 3
                self._albums[name] = PhotoAlbum(
                    self, name, record_name=rn,
                    album_type="folder" if is_folder else "user",
                )
                if is_folder:
                    folders[rn] = name
        except Exception:
            LOGGER.exception("Failed to fetch user albums")

        # Second pass: fetch sub-albums for each folder album.
        for folder_rn, folder_name in folders.items():
            try:
                child_data = self._query({
                    "query": {
                        "recordType": "CPLAlbumByPositionLive",
                        "filterBy": [{
                            "fieldName": "parentId",
                            "comparator": "EQUALS",
                            "fieldValue": {"type": "STRING", "value": folder_rn},
                        }],
                    },
                    "zoneID": self.ZONE_ID,
                    "resultsLimit": 500,
                })
                for record in child_data.get("records", []):
                    rn = record.get("recordName", "")
                    fields = record.get("fields", {})
                    if fields.get("isDeleted", {}).get("value"):
                        continue
                    raw_name = fields.get("albumNameEnc", {}).get("value", "")
                    name = ""
                    if raw_name:
                        try:
                            name = base64.b64decode(raw_name).decode("utf-8")
                        except Exception:
                            name = raw_name
                    if not name:
                        name = fields.get("albumName", {}).get("value", "")
                    if name:
                        self._albums[name] = PhotoAlbum(
                            self, name, record_name=rn, album_type="user",
                            parent_folder=folder_name,
                        )
            except Exception:
                LOGGER.exception("Failed to fetch sub-albums for folder %s", folder_name)

        return self._albums

    def _get_album_count(self, obj_type):
        """Get photo count for an album by its obj_type."""
        try:
            data = self._batch_query({
                "batch": [{
                    "resultsLimit": 1,
                    "query": {
                        "filterBy": {
                            "fieldName": "indexCountID",
                            "fieldValue": {
                                "type": "STRING_LIST",
                                "value": [obj_type],
                            },
                            "comparator": "IN",
                        },
                        "recordType": "HyperionIndexCountLookup",
                    },
                    "zoneWide": True,
                    "zoneID": self.ZONE_ID,
                }],
            })
            records = data.get("batch", [{}])[0].get("records", [])
            if records:
                return records[0].get("fields", {}).get("itemCount", {}).get("value", 0)
        except Exception:
            LOGGER.exception("Failed to get album count for %s", obj_type)
        return 0

    def _get_album_photos(self, album, limit=200, offset=0, direction="ASCENDING"):
        """Fetch photos in an album. Returns list of PhotoAsset.

        CloudKit often returns partial batches (far fewer than requested).
        We iterate internally, advancing startRank by the actual number of
        photos returned, until we've collected `limit` photos or CloudKit
        returns nothing.
        """
        result = []
        current_offset = offset
        # Guard against pathological loops — cap total HTTP calls per request.
        for _ in range(max(limit, 20)):
            if len(result) >= limit:
                break

            filters = [
                {
                    "fieldName": "startRank",
                    "fieldValue": {"type": "INT64", "value": current_offset},
                    "comparator": "EQUALS",
                },
                {
                    "fieldName": "direction",
                    "fieldValue": {"type": "STRING", "value": direction},
                    "comparator": "EQUALS",
                },
            ]

            if album.album_type == "user":
                filters.append({
                    "fieldName": "parentId",
                    "comparator": "EQUALS",
                    "fieldValue": {"type": "STRING", "value": album.record_name},
                })
            elif album.album_type == "smart":
                filters.append({
                    "fieldName": "smartAlbum",
                    "comparator": "EQUALS",
                    "fieldValue": {"type": "STRING", "value": album.smart_filter},
                })

            remaining = limit - len(result)
            data = self._query({
                "query": {
                    "filterBy": filters,
                    "recordType": album.list_type,
                },
                "resultsLimit": max(remaining * 2, 4),
                "zoneID": self.ZONE_ID,
            })

            masters = {}
            assets = {}
            for record in data.get("records", []):
                rt = record.get("recordType", "")
                rn = record.get("recordName", "")
                if rt == "CPLMaster":
                    masters[rn] = record
                elif rt == "CPLAsset":
                    ref = record.get("fields", {}).get(
                        "masterRef", {}
                    ).get("value", {}).get("recordName")
                    if ref:
                        assets[ref] = record

            batch = []
            for master_id, master in masters.items():
                asset = assets.get(master_id)
                batch.append(PhotoAsset(master, asset))

            if not batch:
                break  # end of album

            result.extend(batch)
            step = len(batch) if direction == "ASCENDING" else -len(batch)
            current_offset += step
            if current_offset < 0:
                break

        return result[:limit]

    # ── Shared Library (iOS 16+ family sharing) ────────────────────

    def _private_zones(self):
        """List all zones in the private database."""
        url = "%s/zones/list" % self._service_endpoint
        response = self.session.post(
            url,
            params=self.params,
            data=json.dumps({}),
            headers={"Content-Type": "text/plain"},
        )
        return response.json()

    def _detect_shared_library_zone(self):
        """Find the SharedSync-* zone in the private database.

        The iCloud Shared Library (iOS 16+) stores photos in a private
        zone named 'SharedSync-<UUID>', separate from the personal
        'PrimarySync' zone.  Returns the zone_id dict or None.
        """
        if self._shared_library_zone is not None:
            return self._shared_library_zone or None
        try:
            data = self._private_zones()
            zones = data.get("zones", [])
            zone_names = [z.get("zoneID", {}).get("zoneName", "?") for z in zones]
            LOGGER.debug("Private zones: %s", zone_names)
            for zone in zones:
                zone_id = zone.get("zoneID", {})
                zone_name = zone_id.get("zoneName", "")
                if zone_name.startswith("SharedSync-"):
                    self._shared_library_zone = zone_id
                    LOGGER.info("Shared Library zone found: %s", zone_name)
                    return zone_id
            LOGGER.info("No SharedSync zone among %d zones: %s", len(zones), zone_names)
        except Exception:
            LOGGER.exception("Failed to detect shared library zone")
        self._shared_library_zone = False
        return None

    def _query_zone(self, payload, zone_id):
        """Execute a CloudKit query against a specific private zone."""
        url = "%s/records/query" % self._service_endpoint
        payload["zoneID"] = zone_id
        response = self.session.post(
            url,
            params=self.params,
            data=json.dumps(payload),
            headers={"Content-Type": "text/plain"},
        )
        data = response.json()
        self._check_cloudkit_adp(data)
        return data

    @property
    def has_shared_library(self):
        """Return True if the account has an iCloud Shared Library."""
        return self._detect_shared_library_zone() is not None

    @property
    def shared_library(self):
        """Returns a PhotoAlbum representing the Shared Library, or None."""
        if self._shared_library is not None:
            return self._shared_library or None

        zone_id = self._detect_shared_library_zone()
        if not zone_id:
            self._shared_library = False
            return None

        self._shared_library = PhotoAlbum(
            self, "Shared Library", album_type="all", zone_id=zone_id,
        )
        return self._shared_library

    def _get_shared_library_count(self):
        """Get photo count for the Shared Library zone."""
        zone_id = self._detect_shared_library_zone()
        if not zone_id:
            return 0
        try:
            url = "%s/internal/records/query/batch" % self._service_endpoint
            payload = {
                "batch": [{
                    "resultsLimit": 1,
                    "query": {
                        "filterBy": {
                            "fieldName": "indexCountID",
                            "fieldValue": {
                                "type": "STRING_LIST",
                                "value": ["CPLAssetByAssetDateWithoutHiddenOrDeleted"],
                            },
                            "comparator": "IN",
                        },
                        "recordType": "HyperionIndexCountLookup",
                    },
                    "zoneWide": True,
                    "zoneID": zone_id,
                }],
            }
            response = self.session.post(
                url,
                params=self.params,
                data=json.dumps(payload),
                headers={"Content-Type": "text/plain"},
            )
            data = response.json()
            records = data.get("batch", [{}])[0].get("records", [])
            if records:
                return records[0].get("fields", {}).get("itemCount", {}).get("value", 0)
        except Exception:
            LOGGER.exception("Failed to get shared library count")
        return 0

    def get_shared_library_photos(self, limit=200, offset=0, direction="ASCENDING"):
        """Fetch photos from the Shared Library zone."""
        zone_id = self._detect_shared_library_zone()
        if not zone_id:
            return []

        result = []
        current_offset = offset
        for _ in range(max(limit, 20)):
            if len(result) >= limit:
                break

            data = self._query_zone({
                "query": {
                    "filterBy": [
                        {"fieldName": "startRank",
                         "fieldValue": {"type": "INT64", "value": current_offset},
                         "comparator": "EQUALS"},
                        {"fieldName": "direction",
                         "fieldValue": {"type": "STRING", "value": direction},
                         "comparator": "EQUALS"},
                    ],
                    "recordType": "CPLAssetAndMasterByAssetDateWithoutHiddenOrDeleted",
                },
                "resultsLimit": max((limit - len(result)) * 2, 4),
            }, zone_id)

            masters = {}
            assets = {}
            for record in data.get("records", []):
                rt = record.get("recordType", "")
                rn = record.get("recordName", "")
                if rt == "CPLMaster":
                    masters[rn] = record
                elif rt == "CPLAsset":
                    ref = record.get("fields", {}).get(
                        "masterRef", {}
                    ).get("value", {}).get("recordName")
                    if ref:
                        assets[ref] = record

            batch = []
            for master_id, master in masters.items():
                asset = assets.get(master_id)
                batch.append(PhotoAsset(master, asset))

            if not batch:
                break

            result.extend(batch)
            step = len(batch) if direction == "ASCENDING" else -len(batch)
            current_offset += step
            if current_offset < 0:
                break

        return result[:limit]

    def refresh_shared_library_photo_url(self, photo):
        """Re-fetch a shared library photo's master record for fresh URLs."""
        zone_id = self._detect_shared_library_zone()
        if not zone_id:
            return None
        return self.refresh_photo_url(photo, zone_id=zone_id)

    # ── Shared Albums ──────────────────────────────────────────────

    def _shared_query(self, payload):
        """Execute a CloudKit query against the shared database."""
        url = "%s/records/query" % self._shared_endpoint
        response = self.session.post(
            url,
            params=self.params,
            data=json.dumps(payload),
            headers={"Content-Type": "text/plain"},
        )
        return response.json()

    def _shared_zones(self):
        """List all shared zones (each represents one shared album)."""
        url = "%s/zones/list" % self._shared_endpoint
        response = self.session.post(
            url,
            params=self.params,
            data=json.dumps({}),
            headers={"Content-Type": "text/plain"},
        )
        return response.json()

    @property
    def shared_albums(self):
        """Returns dict of album name -> PhotoAlbum for shared albums."""
        if self._shared_albums is not None:
            return self._shared_albums

        self._shared_albums = {}
        try:
            data = self._shared_zones()
            zones = data.get("zones", [])
            LOGGER.debug("Shared zones response: %d zone(s)", len(zones))
            for zone in zones:
                zone_id = zone.get("zoneID", {})
                zone_name = zone_id.get("zoneName", "")
                if not zone_name or zone_name == "PrimarySync":
                    continue

                # Fetch album metadata from the shared zone
                try:
                    album_data = self._shared_query({
                        "query": {"recordType": "CPLAlbumByPositionLive"},
                        "zoneID": zone_id,
                    })
                    album_name = None
                    for record in album_data.get("records", []):
                        rn = record.get("recordName", "")
                        if rn in ("----Root-Folder----", "----Project-Root-Folder----"):
                            continue
                        fields = record.get("fields", {})
                        raw_name = fields.get("albumNameEnc", {}).get("value", "")
                        if raw_name:
                            try:
                                album_name = base64.b64decode(raw_name).decode("utf-8")
                            except Exception:
                                album_name = raw_name
                            break

                    if not album_name:
                        album_name = zone_name

                    self._shared_albums[album_name] = PhotoAlbum(
                        self, album_name, album_type="shared",
                        zone_id=zone_id,
                    )
                    LOGGER.debug("Found shared album: %s (zone %s)", album_name, zone_name)
                except Exception:
                    LOGGER.warning("Failed to read shared zone %s", zone_name, exc_info=True)

        except Exception:
            LOGGER.warning("Failed to fetch shared albums", exc_info=True)

        return self._shared_albums

    def _get_shared_album_count(self, album):
        """Get photo count for a shared album by querying its zone."""
        try:
            data = self._shared_query({
                "query": {
                    "recordType": "CPLAssetAndMasterByAssetDateWithoutHiddenOrDeleted",
                    "filterBy": [
                        {"fieldName": "startRank",
                         "fieldValue": {"type": "INT64", "value": 0},
                         "comparator": "EQUALS"},
                        {"fieldName": "direction",
                         "fieldValue": {"type": "STRING", "value": "ASCENDING"},
                         "comparator": "EQUALS"},
                    ],
                },
                "resultsLimit": 1,
                "zoneID": album.zone_id,
            })
            records = data.get("records", [])
            # Count masters only (each photo = 1 master + 1 asset)
            count = sum(1 for r in records if r.get("recordType") == "CPLMaster")
            if count > 0:
                return count

            # Fallback: fetch in batches to count
            total = 0
            offset = 0
            for _ in range(100):
                photos = self._get_shared_album_photos(album, limit=200, offset=offset)
                if not photos:
                    break
                total += len(photos)
                offset += len(photos)
            return total
        except Exception:
            LOGGER.exception("Failed to count shared album %s", album.name)
            return 0

    def _get_shared_album_photos(self, album, limit=200, offset=0, direction="ASCENDING"):
        """Fetch photos from a shared album zone."""
        result = []
        current_offset = offset
        for _ in range(max(limit, 20)):
            if len(result) >= limit:
                break

            data = self._shared_query({
                "query": {
                    "filterBy": [
                        {"fieldName": "startRank",
                         "fieldValue": {"type": "INT64", "value": current_offset},
                         "comparator": "EQUALS"},
                        {"fieldName": "direction",
                         "fieldValue": {"type": "STRING", "value": direction},
                         "comparator": "EQUALS"},
                    ],
                    "recordType": album.list_type,
                },
                "resultsLimit": max((limit - len(result)) * 2, 4),
                "zoneID": album.zone_id,
            })

            masters = {}
            assets = {}
            for record in data.get("records", []):
                rt = record.get("recordType", "")
                rn = record.get("recordName", "")
                if rt == "CPLMaster":
                    masters[rn] = record
                elif rt == "CPLAsset":
                    ref = record.get("fields", {}).get(
                        "masterRef", {}
                    ).get("value", {}).get("recordName")
                    if ref:
                        assets[ref] = record

            batch = []
            for master_id, master in masters.items():
                asset = assets.get(master_id)
                batch.append(PhotoAsset(master, asset))

            if not batch:
                break

            result.extend(batch)
            step = len(batch) if direction == "ASCENDING" else -len(batch)
            current_offset += step
            if current_offset < 0:
                break

        return result[:limit]
