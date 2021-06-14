PKG_NAME = c-ares
PKG_VERS = 1.17.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://c-ares.haxx.se/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://c-ares.haxx.se/
COMMENT  = c-ares is a C library for asynchronous DNS requests (including name resolves).
LICENSE  = MIT

GNU_CONFIGURE = 1
CONFIGURE_ARGS = CFLAGS="$(TC_EXTRA_CFLAGS)"

include ../../mk/spksrc.cross-cc.mk
