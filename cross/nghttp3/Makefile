PKG_NAME = nghttp3
PKG_VERS = 1.18.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ngtcp2/nghttp3/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# for supported version for curl 
# see: https://github.com/curl/curl/blob/master/docs/HTTP3.md

DEPENDS = cross/gnutls

HOMEPAGE = https://nghttp2.org/nghttp3/
COMMENT  = HTTP/3 library written in C.
LICENSE  = MIT

# min/max are built on _Generic, which gcc only implements from >= 4.9
MIN_GCC_VERSION = 4.9
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static --enable-lib-only
ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk
