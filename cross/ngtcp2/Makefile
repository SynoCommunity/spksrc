PKG_NAME = ngtcp2
PKG_VERS = 0.15.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ngtcp2/ngtcp2/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# for supported version for curl
# see: https://github.com/curl/curl/blob/master/docs/HTTP3.md
# despite ngtcp2 version 0.16.0 is expected, it works with 0.15.0 only

DEPENDS = cross/gnutls

HOMEPAGE = https://nghttp2.org/ngtcp2/
COMMENT  = ngtcp2 project is an effort to implement IETF QUIC protocol.
LICENSE  = MIT

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static --enable-lib-only --with-gnutls
ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk
