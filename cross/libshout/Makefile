PKG_NAME = libshout
PKG_VERS = 2.4.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.osuosl.org/pub/xiph/releases/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libvorbis cross/libogg cross/openssl

HOMEPAGE = https://icecast.org/
COMMENT  = Libshout is a library for communicating with and sending data to an icecast server.
LICENSE  = LGPL

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
