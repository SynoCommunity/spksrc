PKG_NAME = libpng
PKG_VERS = 1.6.43
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.sourceforge.net/libpng
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

HOMEPAGE = http://www.libpng.org/pub/png/libpng.html
COMMENT  = Portable Network Graphics Library
LICENSE  = http://www.libpng.org/pub/png/src/libpng-LICENSE.txt

CMAKE_ARGS += -DPNG_STATIC=OFF
ADDITIONAL_CFLAGS = -O -lm

include ../../mk/spksrc.cross-cmake.mk
