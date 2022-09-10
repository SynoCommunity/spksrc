PKG_NAME = sqlite-autoconf
PKG_VERS = 3390300
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.sqlite.org/2022
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

HOMEPAGE = https://www.sqlite.org/
COMMENT  = Self-contained, serverless, zero-configuration, transactional SQL database engine.
LICENSE  = Public Domain (https://www.sqlite.org/copyright.html)

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --disable-static-shell

ADDITIONAL_CFLAGS  = -O
ADDITIONAL_CFLAGS += -DSQLITE_ENABLE_COLUMN_METADATA
ADDITIONAL_CFLAGS += -DSQLITE_ENABLE_UNLOCK_NOTIFY

include ../../mk/spksrc.cross-cc.mk
