PKG_NAME = libtheora
PKG_VERS = 1.1.1
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.xiph.org/releases/theora
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libogg cross/libvorbis

HOMEPAGE = http://www.theora.org/
COMMENT  = Theora is a free and open video compression format from the Xiph.org Foundation.
LICENSE  = BSD-Style

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --disable-examples --disable-spec

include ../../mk/spksrc.cross-cc.mk
