PKG_NAME = nghttp2
PKG_VERS = 1.51.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/nghttp2/nghttp2/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl

HOMEPAGE = https://nghttp2.org/
COMMENT  = HTTP/2 C Library and tools.
LICENSE  = MIT

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static
ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk
