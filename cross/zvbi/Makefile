PKG_NAME = zvbi
PKG_VERS = 0.2.35
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.sourceforge.net/project/zapping/$(PKG_NAME)/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpng

HOMEPAGE = https://zapping.sf.net/ZVBI
COMMENT  = Vertical Blanking Interval capture and decoding library
LICENSE  = GPL

GNU_CONFIGURE = 1

PATCHES_LEVEL = 1

include ../../mk/spksrc.cross-cc.mk
