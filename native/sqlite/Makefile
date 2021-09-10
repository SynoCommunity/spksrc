PKG_NAME = sqlite-src
PKG_VERS = 3360000
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.sqlite.org/2021
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = native/zlib

HOMEPAGE = https://www.sqlite.org/
COMMENT  = Self-contained, serverless, zero-configuration, transactional SQL database engine.
LICENSE  = https://www.sqlite.org/copyright.html

GNU_CONFIGURE   = 1
CONFIGURE_ARGS  = --disable-tcl
CONFIGURE_ARGS += --enable-threadsafe
CONFIGURE_ARGS += --enable-threads-override-locks
CONFIGURE_ARGS += --enable-load-extension

ADDITIONAL_CFLAGS  = -DSQLITE_ENABLE_COLUMN_METADATA=1
ADDITIONAL_CFLAGS += -DSQLITE_DISABLE_DIRSYNC=1
ADDITIONAL_CFLAGS += -DSQLITE_ENABLE_FTS3=3
ADDITIONAL_CFLAGS += -DSQLITE_ENABLE_RTREE=1
ADDITIONAL_CFLAGS += -DSQLITE_SECURE_DELETE=1
ADDITIONAL_CFLAGS += -DSQLITE_ENABLE_UNLOCK_NOTIFY=1
ADDITIONAL_CFLAGS += -Wall -fno-strict-aliasing

include ../../mk/spksrc.native-cc.mk
