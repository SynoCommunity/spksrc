PKG_NAME = libsndfile
PKG_VERS = 1.0.28
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.mega-nerd.com/libsndfile/files
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/flac cross/libogg cross/libvorbis

HOMEPAGE = http://www.mega-nerd.com/libsndfile/
COMMENT  = C library for reading and writing files containing sampled sound.
LICENSE  = LGPL

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --disable-static
ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk
