PKG_NAME = libb2
PKG_VERS = 0.98.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/BLAKE2/libb2/releases/download/v${PKG_VERS}
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = https://www.blake2.net/
COMMENT  = C library providing BLAKE2b, BLAKE2s, BLAKE2bp, BLAKE2sp
LICENSE  = CC0-1.0 Universal

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --disable-native
CONFIGURE_ARGS += --disable-static

include ../../mk/spksrc.cross-cc.mk
