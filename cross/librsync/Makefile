PKG_NAME = librsync
PKG_VERS = 0.9.7
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/librsync/$(PKG_NAME)/$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://librsync.sourceforge.net/
COMMENT  = librsync is a free software library that implements the rsync remote-delta algorithm
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static --enable-shared

include ../../mk/spksrc.cross-cc.mk
