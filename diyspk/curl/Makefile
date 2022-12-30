SPK_NAME = curl
SPK_VERS = 7.87.0
SPK_REV = 1

# package of curl with all optional features

DEPENDS = cross/zstd
DEPENDS += cross/curl
# curl build needs additional configuration for mbedtls, gnutls, libssh2, libidn2, websockets
export BUILD_CURL_WITH="mbedtls gnutls libssh2 libidn2 websockets"
export CURL_INCLUDE_EXECUTABLE=1

MAINTAINER = SynoCommunity
DESCRIPTION = Command line tool and library for transferring data with URLs.
STARTABLE = no

HOMEPAGE = https://curl.haxx.se
LICENSE = https://curl.haxx.se/docs/copyright.html

SPK_COMMANDS = bin/curl

include ../../mk/spksrc.spk.mk
