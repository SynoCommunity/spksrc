PKG_NAME = libvorbis
PKG_VERS = 1.3.5
PKG_EXT = tar.xz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.xiph.org/releases/vorbis

DEPENDS = cross/libogg

HOMEPAGE = http://www.vorbis.com/
COMMENT  = Free, open container format
LICENSE  = BSD

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static

include ../../mk/spksrc.cross-cc.mk

