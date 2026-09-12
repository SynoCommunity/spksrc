"""pyicloud_ipd SMS 2FA — from icloudpd v1.32.2 + PR #1325 fix."""
import json
from html.parser import HTMLParser
from typing import Any, List, Mapping, NamedTuple, Sequence, Tuple


class _SMSParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self._is_boot_args = False
        self.sms_data = {}

    def handle_starttag(self, tag, attrs):
        if tag == "script":
            self._is_boot_args = (
                ("type", "application/json") in attrs
                and ("class", "boot_args") in attrs
            )

    def handle_endtag(self, tag):
        if tag == "script":
            self._is_boot_args = False

    def handle_data(self, data):
        if self._is_boot_args:
            self.sms_data = json.loads(data)


class TrustedDevice(NamedTuple):
    id: int
    obfuscated_number: str


def _map_to_trusted_device(device):
    dev_id = device.get("id")
    number = device.get("obfuscatedNumber")
    if dev_id is None or number is None:
        return None
    return TrustedDevice(id=dev_id, obfuscated_number=number.replace("\u2022", "*"))


def parse_trusted_phone_numbers_response(response):
    """Parses html response for the list of available trusted phone numbers."""
    if response.status_code in [200, 204]:
        return parse_trusted_phone_numbers_payload(response.text)
    return []


def parse_trusted_phone_numbers_payload(content):
    """Parses html response for the list of available trusted phone numbers.
    Includes PR #1325 fix: fallback to bridgeInitiateData path."""
    parser = _SMSParser()
    parser.feed(content)
    parser.close()
    twoSV = parser.sms_data.get("direct", {}).get("twoSV", {})
    # Try original path first
    numbers = (
        twoSV.get("phoneNumberVerification", {})
        .get("trustedPhoneNumbers", [])
    )
    # Apple moved trustedPhoneNumbers into bridgeInitiateData (2026+)
    if not numbers:
        numbers = (
            twoSV.get("bridgeInitiateData", {})
            .get("phoneNumberVerification", {})
            .get("trustedPhoneNumbers", [])
        )
    return list(item for item in map(_map_to_trusted_device, numbers) if item is not None)


class AuthenticatedSession(NamedTuple):
    client_id: str
    scnt: str
    session_id: str


WIDGET_KEY = "d39ba9916b7251055b22c7f910e2ea796ee65e98b2ddecea8f5dde8d9d1a815d"


def _oauth_const_headers():
    return {
        "X-Apple-OAuth-Client-Id": WIDGET_KEY,
        "X-Apple-OAuth-Client-Type": "firstPartyAuth",
        "X-Apple-OAuth-Require-Grant-Code": "true",
        "X-Apple-Widget-Key": WIDGET_KEY,
    }


def _oauth_redirect_header(domain):
    return {
        "X-Apple-OAuth-Redirect-URI": "https://www.icloud.com.cn"
        if domain == "cn"
        else "https://www.icloud.com",
    }


def _oauth_headers(auth_session):
    return {
        "X-Apple-OAuth-State": auth_session.client_id,
        "scnt": auth_session.scnt,
        "X-Apple-ID-Session-Id": auth_session.session_id,
    }


def _auth_url(domain):
    return (
        "https://idmsa.apple.com.cn/appleauth/auth"
        if domain == "cn"
        else "https://idmsa.apple.com/appleauth/auth"
    )


class SMSRequest(NamedTuple):
    method: str
    url: str
    headers: dict
    data: str = None
    json_data: dict = None


def build_trusted_phone_numbers_request(domain, oauth_session):
    """Build GET request for trusted phone numbers."""
    return SMSRequest(
        method="GET",
        url=_auth_url(domain),
        headers={
            **_oauth_const_headers(),
            **_oauth_redirect_header(domain),
            **_oauth_headers(oauth_session),
        },
    )


def build_send_sms_code_request(domain, oauth_session, device_id):
    """Build PUT request to send SMS code."""
    return SMSRequest(
        method="PUT",
        url=_auth_url(domain) + "/verify/phone",
        headers={
            **_oauth_const_headers(),
            **_oauth_redirect_header(domain),
            **_oauth_headers(oauth_session),
            "Content-Type": "application/json; charset=utf-8",
        },
        json_data={"phoneNumber": {"id": device_id}, "mode": "sms"},
    )


def build_verify_sms_code_request(domain, oauth_session, device_id, code):
    """Build POST request to verify SMS code."""
    return SMSRequest(
        method="POST",
        url=_auth_url(domain) + "/verify/phone/securitycode",
        headers={
            **_oauth_const_headers(),
            **_oauth_redirect_header(domain),
            **_oauth_headers(oauth_session),
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json; charset=utf-8",
        },
        json_data={
            "phoneNumber": {"id": device_id},
            "securityCode": {"code": code},
            "mode": "sms",
        },
    )
