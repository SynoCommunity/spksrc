PKG_NAME = libshout
PKG_VERS = 2.4.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.osuosl.org/pub/xiph/releases/libshout
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl cross/libvorbis cross/libogg cross/speex cross/libtheora

HOMEPAGE = https://icecast.org/
COMMENT  = Libshout is a library for communicating with and sending data to an icecast server.
LICENSE  = LGPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static --disable-examples --disable-tools
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
