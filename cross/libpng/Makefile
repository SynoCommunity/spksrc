PKG_NAME = libpng
PKG_VERS = 1.6.50
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.sourceforge.net/libpng
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

HOMEPAGE = http://www.libpng.org/pub/png/libpng.html
COMMENT  = Portable Network Graphics Library
LICENSE  = PNG Reference Library License version 2 (http://www.libpng.org/pub/png/src/libpng-LICENSE.txt)

CMAKE_ARGS += -DPNG_STATIC=OFF
CMAKE_ARGS += -DPNG_TOOLS=OFF
CMAKE_ARGS += -DPNG_TESTS=OFF

ADDITIONAL_CFLAGS = -O -lm

# Version scripts fails in Debug build mode
# By default generates a libpng16d.so -> libpng$(PNG_DEBUG_POSTFIX).so
ifeq ($(GCC_DEBUG_INFO),1)
    CMAKE_ARGS += -Dld-version-script=OFF
    CMAKE_ARGS += -DPNG_DEBUG_POSTFIX=""
endif

include ../../mk/spksrc.cross-cmake.mk
