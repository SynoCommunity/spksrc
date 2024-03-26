PKG_NAME = ngtcp2
PKG_VERS = 1.0.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ngtcp2/ngtcp2/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# for supported version for curl
# see: https://github.com/curl/curl/blob/master/docs/HTTP3.md

DEPENDS = cross/gnutls cross/nghttp3

HOMEPAGE = https://nghttp2.org/ngtcp2/
COMMENT  = ngtcp2 project is an effort to implement IETF QUIC protocol.
LICENSE  = MIT

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static --enable-lib-only --with-gnutls
ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk
