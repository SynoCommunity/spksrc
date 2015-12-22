PKG_NAME = sqlite-autoconf
PKG_VERS = 3090200
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.sqlite.org/2015
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/speex

HOMEPAGE = http://www.sqlite.org/
COMMENT  = Self-contained, serverless, zero-configuration, transactional SQL database engine.
LICENSE  = http://www.sqlite.org/copyright.html

GNU_CONFIGURE = 1

ADDITIONAL_CFLAGS = -DSQLITE_ENABLE_COLUMN_METADATA

include ../../mk/spksrc.cross-cc.mk
