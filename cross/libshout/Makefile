PKG_NAME = libshout
PKG_VERS = 2.4.1
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.xiph.org/releases/$(PKG_NAME)

DEPENDS = cross/libogg cross/libvorbis cross/speex cross/speexdsp cross/libtheora cross/openssl

HOMEPAGE = http://www.icecast.org/
COMMENT  = Library which can be used to write a source client like ices
LICENSE  = GPLv2

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --disable-static --enable-shared

include ../../mk/spksrc.cross-cc.mk

