PKG_NAME = sqlite-autoconf
PKG_VERS = 3340100
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.sqlite.org/2021
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

HOMEPAGE = https://www.sqlite.org/
COMMENT  = Self-contained, serverless, zero-configuration, transactional SQL database engine.
LICENSE  = https://www.sqlite.org/copyright.html

GNU_CONFIGURE = 1

ADDITIONAL_CFLAGS = -DSQLITE_ENABLE_COLUMN_METADATA

include ../../mk/spksrc.cross-cc.mk
