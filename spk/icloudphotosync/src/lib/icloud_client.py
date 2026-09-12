"""
iCloud Client — wrapper around pyicloud_ipd for iCloud Photo Sync.

Uses the simplified pyicloud_ipd (based on icloudpd v1.32.2) with
SRP authentication and modern Apple 2FA support.
"""
import os
import sys
import logging

# Add vendor directory for pyicloud_ipd and dependencies
VENDOR_DIR = os.path.join(os.path.dirname(os.path.realpath(__file__)), "vendor")
if os.path.isdir(VENDOR_DIR):
    sys.path.insert(0, VENDOR_DIR)

PYICLOUD_IMPORT_ERROR = None
try:
    from pyicloud_ipd import PyiCloudService
    from pyicloud_ipd.exceptions import (
        PyiCloudFailedLoginException,
        PyiCloudAPIResponseException,
    )
    PYICLOUD_AVAILABLE = True
except Exception as _e:
    PYICLOUD_AVAILABLE = False
    PYICLOUD_IMPORT_ERROR = str(_e)
    PyiCloudService = None
    PyiCloudFailedLoginException = Exception
    PyiCloudAPIResponseException = Exception

from config_manager import get_account_dir

logger = logging.getLogger(__name__)


class ICloudClient:
    """Wraps PyiCloudService with session persistence per account."""

    def __init__(self, account_id, apple_id, password=None):
        self.account_id = account_id
        self.apple_id = apple_id
        self.password = password
        self.session_dir = get_account_dir(account_id)
        self.api = None
        self._error = None

    def login(self):
        """Attempt login. Returns dict with status info."""
        if not PYICLOUD_AVAILABLE:
            return {
                "success": False,
                "error": "pyicloud not available: %s" % (PYICLOUD_IMPORT_ERROR or "not installed"),
            }

        try:
            self.api = PyiCloudService(
                domain="com",
                apple_id=self.apple_id,
                password=self.password,
                cookie_directory=self.session_dir,
            )

            if self.api.requires_2fa:
                # Explicitly request push notification to trusted devices
                self.api.request_2fa_push()
                return {
                    "success": True,
                    "requires_2fa": True,
                    "message": "2FA code required",
                }

            if self.api.requires_2sa:
                return {
                    "success": True,
                    "requires_2fa": True,
                    "message": "2-step verification required",
                }

            return {
                "success": True,
                "requires_2fa": False,
                "message": "Login successful",
            }

        except PyiCloudFailedLoginException as e:
            # Extract clean error message from nested exceptions
            msg = str(e)
            # Try to extract Apple's actual error message
            if "serviceErrors" in msg or "Check the account" in msg:
                import re
                m = re.search(r'"message"\s*:\s*"([^"]+)"', msg)
                if m:
                    msg = m.group(1)
            return {"success": False, "error": msg}
        except Exception as e:
            logger.exception("Login error")
            return {"success": False, "error": "Connection error: %s" % str(e)}

    def _restore_session_for_2fa(self):
        """Restore a session that's waiting for 2FA (e.g. after CGI process restart)."""
        if self.api:
            return True
        if not PYICLOUD_AVAILABLE:
            return False
        try:
            # Load session data + cookies WITHOUT calling authenticate()
            self.api = PyiCloudService(
                domain="com",
                apple_id=self.apple_id,
                cookie_directory=self.session_dir,
                auto_authenticate=False,
            )
            # Mark as needing 2FA so the verify methods work
            self.api.data = {"hsaChallengeRequired": True, "dsInfo": {"hsaVersion": 2, "hasICloudQualifyingDevice": True}}
            return True
        except Exception as e:
            logger.exception("Failed to restore session for 2FA")
            return False

    def send_sms_code(self):
        """Re-login and request a 2FA code via SMS.
        Needs fresh login because Apple session tokens are short-lived.
        """
        if not PYICLOUD_AVAILABLE:
            return {"success": False, "error": "pyicloud not available"}
        if not self.password:
            return {"success": False, "error": "Password not available for re-login"}

        try:
            # Fresh SRP login to get new session tokens
            self.api = PyiCloudService(
                domain="com",
                apple_id=self.apple_id,
                password=self.password,
                cookie_directory=self.session_dir,
            )

            if not self.api.requires_2fa:
                return {"success": True, "message": "No 2FA needed"}

            phones = self.api.get_trusted_phone_numbers()
            if not phones:
                return {"success": False, "error": "No trusted phone numbers found"}

            result = self.api.send_2fa_code_sms(phones[0].id)
            if result:
                return {
                    "success": True,
                    "phone_id": phones[0].id,
                    "phone_number": phones[0].obfuscated_number,
                    "message": "SMS sent to %s" % phones[0].obfuscated_number,
                }
            return {"success": False, "error": "Could not send SMS"}
        except Exception as e:
            logger.exception("SMS send error")
            return {"success": False, "error": str(e)}

    def verify_2fa(self, code, phone_id=None):
        """Submit 2FA code. Returns dict with status info.
        If phone_id is given, uses SMS verification. Otherwise tries trusted device push.
        """
        if not self.api:
            if not self._restore_session_for_2fa():
                return {"success": False, "error": "Not logged in"}

        try:
            if self.api.requires_2fa:
                if phone_id:
                    # SMS-based verification
                    result = self.api.validate_2fa_code_sms(int(phone_id), code)
                else:
                    # Trusted device push verification
                    result = self.api.validate_2fa_code(code)

                if result:
                    return {"success": True, "message": "2FA verified"}
                return {"success": False, "error": "Invalid 2FA code"}

            # Legacy 2SA — older accounts
            if self.api.requires_2sa:
                devices = self.api.trusted_devices
                if devices:
                    result = self.api.validate_verification_code(devices[0], code)
                    if result:
                        return {"success": True, "message": "Verification successful"}
                return {"success": False, "error": "Invalid verification code"}

            return {"success": True, "message": "No 2FA required"}

        except Exception as e:
            logger.exception("2FA verification error")
            return {"success": False, "error": str(e)}

    def restore_session(self):
        """Try to restore a previously authenticated session."""
        if not PYICLOUD_AVAILABLE:
            return False

        try:
            self.api = PyiCloudService(
                domain="com",
                apple_id=self.apple_id,
                cookie_directory=self.session_dir,
            )
            if not self.api.data.get("dsInfo"):
                logger.warning("Session restore returned no account data for %s", self.apple_id)
                return False
            return not (self.api.requires_2fa or self.api.requires_2sa)
        except Exception:
            return False

    def is_authenticated(self):
        """Check if the current session is valid."""
        if not self.api or not self.api.data.get("dsInfo"):
            return False
        try:
            return not (self.api.requires_2fa or self.api.requires_2sa)
        except Exception:
            return False

    @property
    def photos(self):
        """Access iCloud Photos service."""
        if self.api and self.is_authenticated():
            return self.api.photos
        return None


# Cache of active clients keyed by account_id
_clients = {}


def get_client(account_id, apple_id, password=None):
    """Get or create an ICloudClient for the given account.

    A cached client whose session no longer authenticates is evicted so
    the caller gets a fresh instance — otherwise stale auth state lingers
    until process restart and every sync silently fails.
    """
    cached = _clients.get(account_id)
    if cached is not None:
        if cached.apple_id == apple_id and cached.is_authenticated():
            return cached
        _clients.pop(account_id, None)
    client = ICloudClient(account_id, apple_id, password)
    _clients[account_id] = client
    return client


def remove_client(account_id):
    """Remove a cached client."""
    _clients.pop(account_id, None)
