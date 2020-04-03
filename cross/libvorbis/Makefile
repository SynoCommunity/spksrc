PKG_NAME = libvorbis
PKG_VERS = 1.3.6
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.xiph.org/releases/vorbis
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libogg

HOMEPAGE = http://www.vorbis.com/
COMMENT  = Free, open container format
LICENSE  = BSD

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
