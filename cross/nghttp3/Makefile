PKG_NAME = nghttp3
PKG_VERS = 0.8.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ngtcp2/nghttp3/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/gnutls

# archs without C++11 support
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

HOMEPAGE = https://nghttp2.org/nghttp3/
COMMENT  = HTTP/3 library written in C.
LICENSE  = MIT

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static --enable-lib-only
ADDITIONAL_CFLAGS = -O2 -std=c++11

include ../../mk/spksrc.cross-cc.mk
