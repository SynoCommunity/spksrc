"""
pyicloud_ipd base — simplified from icloudpd v1.32.2.

Stripped: foundation dependency, observer pattern, CN domain support.
Kept: SRP authentication, 2FA, session persistence, Photos service.
"""
import base64
import hashlib
import http.cookiejar as cookielib
import json
import logging
import typing
from os import mkdir, path
from re import match
from tempfile import gettempdir
from uuid import uuid1

import srp

from pyicloud_ipd.exceptions import (
    PyiCloudAPIResponseException,
    PyiCloudConnectionException,
    PyiCloudFailedLoginException,
    PyiCloudServiceNotActivatedException,
)
from pyicloud_ipd.session import PyiCloudPasswordFilter, PyiCloudSession
from pyicloud_ipd.sms import (
    AuthenticatedSession,
    build_send_sms_code_request,
    build_trusted_phone_numbers_request,
    build_verify_sms_code_request,
    parse_trusted_phone_numbers_response,
)

LOGGER = logging.getLogger(__name__)

AUTH_ENDPOINT = "https://idmsa.apple.com/appleauth/auth"
HOME_ENDPOINT = "https://www.icloud.com"
SETUP_ENDPOINT = "https://setup.icloud.com/setup/ws/1"
WIDGET_KEY = "d39ba9916b7251055b22c7f910e2ea796ee65e98b2ddecea8f5dde8d9d1a815d"


class PyiCloudService:
    """
    iCloud authentication service using SRP (Secure Remote Password).

    Usage:
        from pyicloud_ipd import PyiCloudService
        api = PyiCloudService("com", "user@apple.com", password="secret",
                              cookie_directory="/path/to/cookies")
    """

    def __init__(
        self,
        domain="com",
        apple_id=None,
        password=None,
        cookie_directory=None,
        verify=True,
        client_id=None,
        http_timeout=30.0,
        auto_authenticate=True,
    ):
        self.apple_id = apple_id
        self._password = password
        self.data = {}
        self.params = {}
        self.client_id = client_id or ("auth-%s" % str(uuid1()).lower())
        self.http_timeout = http_timeout
        self.password_filter = None
        self.domain = domain

        if domain == "com":
            self.AUTH_ENDPOINT = AUTH_ENDPOINT
            self.HOME_ENDPOINT = HOME_ENDPOINT
            self.SETUP_ENDPOINT = SETUP_ENDPOINT
        elif domain == "cn":
            self.AUTH_ENDPOINT = "https://idmsa.apple.com.cn/appleauth/auth"
            self.HOME_ENDPOINT = "https://www.icloud.com.cn"
            self.SETUP_ENDPOINT = "https://setup.icloud.com.cn/setup/ws/1"
        else:
            raise NotImplementedError("Domain '%s' is not supported" % domain)

        # Cookie directory
        if cookie_directory:
            self._cookie_directory = path.expanduser(path.normpath(cookie_directory))
            if not path.exists(self._cookie_directory):
                mkdir(self._cookie_directory, 0o700)
        else:
            topdir = path.join(gettempdir(), "pyicloud")
            self._cookie_directory = topdir
            if not path.exists(self._cookie_directory):
                mkdir(self._cookie_directory, 0o700)

        # Session data (persisted across requests)
        self.session_data = {}
        try:
            with open(self.session_path, encoding="utf-8") as f:
                self.session_data = json.load(f)
        except (FileNotFoundError, json.JSONDecodeError):
            pass

        session_client_id = self.session_data.get("client_id")
        if session_client_id:
            self.client_id = session_client_id
        else:
            self.session_data["client_id"] = self.client_id

        # HTTP session
        self.session = PyiCloudSession(self)
        self.session.verify = verify
        self.session.headers.update({
            "Origin": self.HOME_ENDPOINT,
            "Referer": "%s/" % self.HOME_ENDPOINT,
            "User-Agent": (
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
                "AppleWebKit/537.36 (KHTML, like Gecko) "
                "Chrome/138.0.0.0 Safari/537.36"
            ),
        })

        # Cookies
        cookiejar_path = self.cookiejar_path
        self.session.cookies = cookielib.LWPCookieJar(filename=cookiejar_path)
        if path.exists(cookiejar_path):
            try:
                self.session.cookies.load(ignore_discard=True, ignore_expires=True)
            except (FileNotFoundError, OSError):
                LOGGER.warning("Failed to read cookiejar %s", cookiejar_path)

        self.params = {
            "clientBuildNumber": "2522Project44",
            "clientMasteringNumber": "2522B2",
            "clientId": self.client_id,
        }

        self._webservices = {}
        self._photos = None

        if auto_authenticate:
            self.authenticate()

    def authenticate(self, force_refresh=False):
        """Handles authentication with session token or SRP."""
        login_successful = False

        if self.session_data.get("session_token") and not force_refresh:
            LOGGER.debug("Checking session token validity")
            try:
                self.data = self._validate_token()
                login_successful = True
            except PyiCloudAPIResponseException:
                LOGGER.debug("Invalid authentication token, will log in from scratch.")

        if not login_successful:
            if not self._password:
                LOGGER.debug("No password provided")
                return

            self.password_filter = PyiCloudPasswordFilter(self._password)
            LOGGER.addFilter(self.password_filter)
            LOGGER.debug("Authenticating as %s", self.apple_id)

            self._authenticate_srp(self._password)
            self._authenticate_with_token()

        self.params.update({"dsid": self.data["dsInfo"]["dsid"]})
        self._webservices = self.data.get("webservices", {})
        LOGGER.info("Authentication completed successfully")

    def _authenticate_with_token(self):
        """Authenticate using session token."""
        data = {
            "accountCountryCode": self.session_data.get("account_country"),
            "dsWebAuthToken": self.session_data.get("session_token"),
            "extended_login": True,
            "trustToken": self.session_data.get("trust_token", ""),
        }
        try:
            req = self.session.post(
                "%s/accountLogin" % self.SETUP_ENDPOINT,
                data=json.dumps(data),
            )
            self.data = req.json()
        except PyiCloudAPIResponseException as error:
            raise PyiCloudFailedLoginException(
                "Invalid authentication token.", error
            ) from error

        domain_to_use = self.data.get("domainToUse")
        if domain_to_use is not None:
            raise PyiCloudConnectionException(
                "Apple insists on using %s. Please use --domain parameter" % domain_to_use
            )

    def _authenticate_srp(self, password):
        """SRP (Secure Remote Password) authentication with Apple."""

        class SrpPassword:
            def __init__(self, password):
                self.pwd = password

            def set_encrypt_info(self, protocol, salt, iterations):
                self.protocol = protocol
                self.salt = salt
                self.iterations = iterations

            def encode(self):
                password_hash = hashlib.sha256(self.pwd.encode())
                password_digest = (
                    password_hash.hexdigest().encode()
                    if self.protocol == "s2k_fo"
                    else password_hash.digest()
                )
                return hashlib.pbkdf2_hmac(
                    "sha256", password_digest, self.salt, self.iterations, 32
                )

        srp_password = SrpPassword(password)
        srp.rfc5054_enable()
        srp.no_username_in_x()
        usr = srp.User(
            self.apple_id, srp_password, hash_alg=srp.SHA256, ng_type=srp.NG_2048
        )
        uname, A = usr.start_authentication()

        # Step 1: Send public key A to server
        data = {
            "a": base64.b64encode(A).decode(),
            "accountName": uname,
            "protocols": ["s2k", "s2k_fo"],
        }
        headers = self._get_auth_headers({
            "Origin": "https://idmsa.apple.com",
            "Referer": "https://idmsa.apple.com/",
        })

        try:
            response = self.session.post(
                "%s/signin/init" % self.AUTH_ENDPOINT,
                data=json.dumps(data),
                headers=headers,
            )
            if response.status_code == 401:
                raise PyiCloudAPIResponseException(response.text, str(response.status_code))
        except PyiCloudAPIResponseException as error:
            raise PyiCloudFailedLoginException(
                "Failed to initiate SRP authentication.", error
            ) from error

        # Step 2: Receive server's public key B, salt, iterations
        body = response.json()
        salt = base64.b64decode(body["salt"])
        b = base64.b64decode(body["b"])
        c = body["c"]
        iterations = body["iteration"]
        protocol = body["protocol"]

        # Step 3: Generate session proof M1, M2
        srp_password.set_encrypt_info(protocol, salt, iterations)
        m1 = usr.process_challenge(salt, b)
        m2 = usr.H_AMK

        data = {
            "accountName": uname,
            "c": c,
            "m1": base64.b64encode(m1).decode(),
            "m2": base64.b64encode(m2).decode(),
            "rememberMe": True,
            "trustTokens": [],
        }
        if self.session_data.get("trust_token"):
            data["trustTokens"] = [self.session_data.get("trust_token")]

        try:
            response = self.session.post(
                "%s/signin/complete" % self.AUTH_ENDPOINT,
                params={"isRememberMeEnabled": "true"},
                data=json.dumps(data),
                headers=headers,
            )
            if response.status_code == 409:
                # 2FA required — this is expected
                pass
            elif response.status_code == 412:
                # Non-2FA account, repair needed
                headers = self._get_auth_headers()
                response = self.session.post(
                    "%s/repair/complete" % self.AUTH_ENDPOINT,
                    data=json.dumps({}),
                    headers=headers,
                )
            elif 400 <= response.status_code < 600:
                raise PyiCloudAPIResponseException(
                    response.text, str(response.status_code)
                )
        except PyiCloudAPIResponseException as error:
            raise PyiCloudFailedLoginException(
                "Invalid email/password combination.", error
            ) from error

    def _validate_token(self):
        """Check if current session token is still valid."""
        headers = {
            "Origin": self.HOME_ENDPOINT,
            "Referer": "%s/" % self.HOME_ENDPOINT,
        }
        try:
            response = self.session.post(
                "%s/validate" % self.SETUP_ENDPOINT,
                data="null",
                headers=headers,
            )
            return response.json()
        except PyiCloudAPIResponseException as err:
            LOGGER.debug("Invalid authentication token")
            raise err

    def _get_auth_headers(self, overrides=None):
        """Build headers for Apple auth endpoints."""
        headers = {
            "Accept": "application/json, text/javascript",
            "Content-Type": "application/json",
            "X-Apple-OAuth-Client-Id": WIDGET_KEY,
            "X-Apple-OAuth-Client-Type": "firstPartyAuth",
            "X-Apple-OAuth-Redirect-URI": self.HOME_ENDPOINT,
            "X-Apple-OAuth-Require-Grant-Code": "true",
            "X-Apple-OAuth-Response-Mode": "web_message",
            "X-Apple-OAuth-Response-Type": "code",
            "X-Apple-OAuth-State": self.client_id,
            "X-Apple-Widget-Key": WIDGET_KEY,
        }
        scnt = self.session_data.get("scnt")
        if scnt:
            headers["scnt"] = scnt
        session_id = self.session_data.get("session_id")
        if session_id:
            headers["X-Apple-ID-Session-Id"] = session_id
        if overrides:
            headers.update(overrides)
        return headers

    # --- Properties ---

    @property
    def cookiejar_path(self):
        return path.join(
            self._cookie_directory,
            "".join([c for c in self.apple_id if match(r"\w", c)]),
        )

    @property
    def session_path(self):
        return path.join(
            self._cookie_directory,
            "".join([c for c in self.apple_id if match(r"\w", c)]) + ".session",
        )

    @property
    def requires_2sa(self):
        """Returns True if two-step authentication is required."""
        return self.data.get("dsInfo", {}).get("hsaVersion", 0) >= 1 and (
            self.data.get("hsaChallengeRequired", False) or not self.is_trusted_session
        )

    @property
    def requires_2fa(self):
        """Returns True if two-factor authentication is required."""
        return (
            self.data.get("dsInfo", {}).get("hsaVersion", 0) == 2
            and (
                self.data.get("hsaChallengeRequired", False)
                or not self.is_trusted_session
            )
            and self.data.get("dsInfo", {}).get("hasICloudQualifyingDevice", False)
        )

    @property
    def is_trusted_session(self):
        return self.data.get("hsaTrustedBrowser", False)

    # --- 2FA Methods ---

    def request_2fa_push(self):
        """Request a 2FA push notification to trusted devices."""
        headers = self._get_auth_headers()
        try:
            response = self.session.get(
                "%s/verify/trusteddevice" % self.AUTH_ENDPOINT,
                headers=headers,
            )
            LOGGER.debug("2FA push request status: %s", response.status_code)
            return response.ok
        except Exception:
            LOGGER.debug("2FA push request failed")
            return False

    def validate_2fa_code(self, code):
        """Verify a 2FA code received on a trusted device."""
        data = {"securityCode": {"code": code}}
        headers = self._get_auth_headers({"Accept": "application/json"})
        try:
            self.session.post(
                "%s/verify/trusteddevice/securitycode" % self.AUTH_ENDPOINT,
                data=json.dumps(data),
                headers=headers,
            )
        except PyiCloudAPIResponseException as error:
            if str(error.code) == "-21669":
                LOGGER.error("Code verification failed.")
                return False
            raise

        LOGGER.debug("Code verification successful.")
        self.trust_session()
        return not self.requires_2sa

    def trust_session(self):
        """Request session trust to avoid future 2FA prompts."""
        headers = self._get_auth_headers()
        try:
            self.session.get(
                "%s/2sv/trust" % self.AUTH_ENDPOINT,
                headers=headers,
            )
            self._authenticate_with_token()
            return True
        except PyiCloudAPIResponseException:
            LOGGER.error("Session trust failed.")
            return False

    def get_oauth_session(self):
        return AuthenticatedSession(
            client_id=self.client_id,
            scnt=self.session_data["scnt"],
            session_id=self.session_data["session_id"],
        )

    def get_trusted_phone_numbers(self):
        """Returns list of trusted phone numbers for SMS 2FA."""
        oauth = self.get_oauth_session()
        req = build_trusted_phone_numbers_request(self.domain, oauth)
        import requests
        prepared = requests.Request(
            method=req.method, url=req.url, headers=req.headers
        ).prepare()
        response = self.session.send(prepared)
        return parse_trusted_phone_numbers_response(response)

    def send_2fa_code_sms(self, device_id):
        """Request a 2FA code via SMS."""
        oauth = self.get_oauth_session()
        req = build_send_sms_code_request(self.domain, oauth, device_id)
        import requests
        prepared = requests.Request(
            method=req.method,
            url=req.url,
            headers=req.headers,
            json=req.json_data,
        ).prepare()
        response = self.session.send(prepared)
        return response.ok

    def validate_2fa_code_sms(self, device_id, code):
        """Verify a 2FA code received via SMS."""
        oauth = self.get_oauth_session()
        req = build_verify_sms_code_request(self.domain, oauth, device_id, code)
        import requests
        prepared = requests.Request(
            method=req.method,
            url=req.url,
            headers=req.headers,
            json=req.json_data,
        ).prepare()
        response = self.session.send(prepared)
        if response.ok:
            return self.trust_session()
        return False

    # --- 2SA (legacy two-step) ---

    @property
    def trusted_devices(self):
        request = self.session.get(
            "%s/listDevices" % self.SETUP_ENDPOINT, params=self.params
        )
        devices = request.json().get("devices")
        return devices or []

    def send_verification_code(self, device):
        data = json.dumps(device)
        request = self.session.post(
            "%s/sendVerificationCode" % self.SETUP_ENDPOINT,
            params=self.params,
            data=data,
        )
        return request.json().get("success", False)

    def validate_verification_code(self, device, code):
        device.update({"verificationCode": code, "trustBrowser": True})
        data = json.dumps(device)
        try:
            self.session.post(
                "%s/validateVerificationCode" % self.SETUP_ENDPOINT,
                params=self.params,
                data=data,
            )
        except PyiCloudAPIResponseException as error:
            if str(error.code) == "-21669":
                return False
            raise
        self._authenticate_with_token()
        return not self.requires_2sa

    # --- Services ---

    @property
    def photos(self):
        if not self._photos:
            service_root = self._webservices.get("ckdatabasews", {}).get("url")
            if not service_root:
                raise PyiCloudServiceNotActivatedException(
                    "Photos service not available", "ckdatabasews"
                )
            # Import here to avoid circular imports
            from pyicloud_ipd.services.photos import PhotosService
            self._photos = PhotosService(service_root, self.session, self.params)
        return self._photos

    def __str__(self):
        return "iCloud API: %s" % self.apple_id

    def __repr__(self):
        return "<%s>" % str(self)
