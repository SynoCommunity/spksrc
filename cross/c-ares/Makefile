PKG_NAME = c-ares
PKG_VERS = 1.12.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://c-ares.haxx.se/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://c-ares.haxx.se/
COMMENT  = c-ares is a C library that performs DNS requests and name resolves asynchronously
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = CFLAGS=$(TC_CFLAGS)

include ../../mk/spksrc.cross-cc.mk

