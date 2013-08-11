PKG_NAME = libpng
PKG_VERS = 1.5.17
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.simplesystems.org/pub/png/src/libpng15
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

HOMEPAGE = http://www.libpng.org/pub/png/libpng.html
COMMENT  = Portable Network Graphics Library
LICENSE  = http://www.libpng.org/pub/png/src/libpng-LICENSE.txt

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
