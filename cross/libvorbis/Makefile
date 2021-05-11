PKG_NAME = libvorbis
PKG_VERS = 1.3.7
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.osuosl.org/pub/xiph/releases/vorbis
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libogg

HOMEPAGE = https://xiph.org/vorbis
COMMENT  = Free, open container format
LICENSE  = BSD

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
