PKG_NAME = frei0r
PKG_VERS = 2.3.3
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/dyne/frei0r/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/freetype cross/cairo

HOMEPAGE = https://frei0r.dyne.org/
COMMENT  = Frei0r is a minimalistic plugin API for video effects.
LICENSE  = GPL-2.0

REQUIRED_MIN_DSM = 7
# Needs gcc >= 7.5: needs C++17, i.e. gcc 7 or newer.
MIN_GCC_VERSION = 7.5
REQUIRED_MIN_SRM = 1.3

CMAKE_USE_TOOLCHAIN_FILE = OFF

CONFIGURE_ARGS  = -DCMAKE_BUILD_TYPE=Release
CONFIGURE_ARGS += -DURIPARSER_BUILD_DOCS=OFF
CONFIGURE_ARGS += -DURIPARSER_BUILD_TESTS=OFF

include ../../mk/spksrc.cross-cmake.mk
