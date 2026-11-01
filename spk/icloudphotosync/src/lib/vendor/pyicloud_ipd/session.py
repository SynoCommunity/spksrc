"""pyicloud_ipd session — simplified from icloudpd v1.32.2."""
import inspect
import json
import logging
import os

from requests import Session

from pyicloud_ipd.exceptions import (
    PyiCloud2SARequiredException,
    PyiCloudADPProtectionException,
    PyiCloudAPIResponseException,
    PyiCloudServiceNotActivatedException,
    PyiCloudServiceUnavailableException,
)

LOGGER = logging.getLogger(__name__)

HEADER_DATA = {
    "X-Apple-ID-Account-Country": "account_country",
    "X-Apple-ID-Session-Id": "session_id",
    "X-Apple-Session-Token": "session_token",
    "X-Apple-TwoSV-Trust-Token": "trust_token",
    "X-Apple-TwoSV-Trust-Eligible": "trust_eligible",
    "X-Apple-I-Rscd": "apple_rscd",
    "X-Apple-I-Ercd": "apple_ercd",
    "scnt": "scnt",
}


class PyiCloudPasswordFilter(logging.Filter):
    def __init__(self, password):
        super().__init__(password)

    def filter(self, record):
        message = record.getMessage()
        if self.name in message:
            record.msg = message.replace(self.name, "********")
            record.args = []
        return True


class PyiCloudSession(Session):
    """iCloud session with Apple auth header extraction and error handling."""

    def __init__(self, service):
        self.service = service
        super().__init__()

    def request(self, method, url, **kwargs):
        # Charge logging to the right service endpoint
        try:
            callee = inspect.stack()[2]
            module = inspect.getmodule(callee[0])
            mod_name = module.__name__ if module else __name__
        except Exception:
            mod_name = __name__
        request_logger = logging.getLogger(mod_name).getChild("http")
        if (
            self.service.password_filter
            and self.service.password_filter not in request_logger.filters
        ):
            request_logger.addFilter(self.service.password_filter)

        request_logger.debug("%s %s %s", method, url, kwargs.get("data", ""))

        if "timeout" not in kwargs and self.service.http_timeout is not None:
            kwargs["timeout"] = self.service.http_timeout

        response = super().request(method, url, **kwargs)

        # Handle 503
        if response.status_code == 503:
            raise PyiCloudServiceUnavailableException(
                "Apple iCloud is temporarily refusing requests"
            )

        content_type = response.headers.get("Content-Type", "").split(";")[0]
        json_mimetypes = ["application/json", "text/json"]

        # Extract Apple auth headers into session_data
        for header, value in HEADER_DATA.items():
            if response.headers.get(header):
                self.service.session_data[value] = response.headers.get(header)

        # Save session_data to file. Atomic write because multiple CGI
        # handlers may invoke API calls concurrently for the same account
        # — a half-written session file means the next request loses the
        # trust token and the user gets bounced to re-auth.
        try:
            tmp = self.service.session_path + ".tmp"
            fd = os.open(tmp, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600)
            with os.fdopen(fd, "w", encoding="utf-8") as f:
                json.dump(self.service.session_data, f)
                f.flush()
                try:
                    os.fsync(f.fileno())
                except OSError:
                    pass
            os.replace(tmp, self.service.session_path)
        except Exception:
            pass

        # Save cookies
        try:
            self.cookies.save(ignore_discard=True, ignore_expires=True)
            try:
                os.chmod(self.cookies.filename, 0o600)
            except OSError:
                pass
        except Exception:
            pass

        if not response.ok and (
            content_type not in json_mimetypes or response.status_code in [421, 450, 500]
        ):
            self._raise_error(str(response.status_code), response.reason)

        if content_type not in json_mimetypes:
            if self.service.session_data.get("apple_rscd") == "401":
                self._raise_error("401", "Invalid username/password combination.")
            return response

        try:
            data = response.json() if response.status_code != 204 else {}
        except ValueError:
            request_logger.warning("Failed to parse response with JSON mimetype")
            return response

        if isinstance(data, dict):
            if data.get("hasError"):
                errors = data.get("service_errors")
                code = None
                reason = None
                if errors:
                    code = errors[0].get("code")
                    reason = errors[0].get("message")
                self._raise_error(code or "Unknown", reason or "Unknown")
            elif not data.get("success"):
                reason = data.get("errorMessage")
                reason = reason or data.get("reason")
                reason = reason or data.get("errorReason")
                if not reason and isinstance(data.get("error"), str):
                    reason = data.get("error")
                if not reason and data.get("error"):
                    reason = "Unknown reason"

                code = data.get("errorCode")
                if not code and data.get("serverErrorCode"):
                    code = data.get("serverErrorCode")
                if not code and data.get("error"):
                    code = data.get("error")

                if reason:
                    self._raise_error(code or "Unknown", reason)

        return response

    def _raise_error(self, code, reason):
        if (
            self.service.requires_2sa
            and reason == "Missing X-APPLE-WEBAUTH-TOKEN cookie"
        ):
            raise PyiCloud2SARequiredException(self.service.apple_id)
        if code in ("ZONE_NOT_FOUND", "AUTHENTICATION_FAILED"):
            reason = (
                "Please log into https://icloud.com/ to manually "
                "finish setting up your iCloud service"
            )
            raise PyiCloudServiceNotActivatedException(reason, code)
        if code == "ACCESS_DENIED":
            reason_lower = (reason or "").lower()
            if any(kw in reason_lower for kw in (
                "private database", "private db", "not accessible",
                "not available", "end-to-end", "advanced data protection",
                "disabled for this account",
            )):
                raise PyiCloudADPProtectionException(reason)
            reason = (
                reason + ". Please wait a few minutes then try again. "
                "The remote servers might be trying to throttle requests."
            )
        if code in ["421", "450", "500"]:
            reason = "Authentication required for Account."

        raise PyiCloudAPIResponseException(reason, code)
