PKG_NAME = ezstream
PKG_VERS = 1.0.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.xiph.org/releases/ezstream
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = cross/libcheck 
DEPENDS = cross/zlib cross/libpng cross/libxml2
DEPENDS += cross/taglib cross/libvorbis cross/speex cross/libtheora cross/libogg cross/libshout

HOMEPAGE = https://www.icecast.org/
COMMENT  = EZStream is a command line source client for Icecast media streaming servers.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
