PKG_NAME = libpar2
PKG_SHORT_VERS = 0.2
PKG_VERS = $(PKG_SHORT_VERS).1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://launchpad.net/libpar2/$(PKG_SHORT_VERS)/$(PKG_VERS)/+download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libsigc++

HOMEPAGE = http://parchive.sourceforge.net/
COMMENT  = Library for par2
LICENSE  = GPL

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

