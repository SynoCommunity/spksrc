"""pyicloud_ipd exceptions — simplified from icloudpd v1.32.2."""


class PyiCloudException(Exception):
    """Generic iCloud exception."""
    pass


class PyiCloudAPIResponseException(PyiCloudException):
    """iCloud response exception."""

    def __init__(self, reason, code=None):
        self.reason = reason
        self.code = code
        message = reason or ""
        if code:
            message += " (%s)" % code
        super().__init__(message)


class PyiCloudServiceNotActivatedException(PyiCloudAPIResponseException):
    pass


class PyiCloudServiceUnavailableException(PyiCloudException):
    pass


class PyiCloudConnectionException(PyiCloudException):
    pass


class PyiCloudFailedLoginException(PyiCloudException):
    pass


class PyiCloud2SARequiredException(PyiCloudException):
    def __init__(self, apple_id):
        message = "Two-step authentication required for account: %s" % apple_id
        super().__init__(message)


class PyiCloudADPProtectionException(PyiCloudException):
    """Raised when iCloud Advanced Data Protection blocks web API access."""

    def __init__(self, reason=None):
        message = (
            "iCloud Advanced Data Protection (ADP) is enabled on this account. "
            "ADP encrypts iCloud Photos end-to-end, which blocks web-API access. "
            "To use this app, either disable ADP for iCloud Photos in your Apple "
            "device settings (Settings > Apple ID > iCloud > Advanced Data "
            "Protection), or enable temporary web access at icloud.com."
        )
        if reason:
            message += " (Detail: %s)" % reason
        super().__init__(message)
