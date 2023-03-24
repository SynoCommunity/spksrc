SPK_NAME = curl
SPK_VERS = 7.88.1
SPK_REV = 1

# package of curl with all optional features

DEPENDS = cross/curl
# curl needs additional configuration for building with these features:
export BUILD_CURL_WITH="mbedtls gnutls libssh2 libidn2 libpsl librtmp nghttp2 nghttp3 gsasl gss ldap zstd brotli websockets"
export CURL_INCLUDE_EXECUTABLE=1

MAINTAINER = SynoCommunity
DESCRIPTION = Command line tool and library for transferring data with URLs.
STARTABLE = no

HOMEPAGE = https://curl.haxx.se
LICENSE = https://curl.haxx.se/docs/copyright.html

SPK_COMMANDS = bin/curl

include ../../mk/spksrc.spk.mk
