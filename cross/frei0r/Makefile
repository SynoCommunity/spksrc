PKG_NAME = frei0r
PKG_VERS = 1.8.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/dyne/frei0r/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/freetype

HOMEPAGE = https://frei0r.dyne.org/
COMMENT  = Frei0r is a minimalistic plugin API for video effects.
LICENSE  = GPL-2.0

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

CMAKE_ARGS  = -DCMAKE_BUILD_TYPE=Release
CMAKE_ARGS += -DURIPARSER_BUILD_DOCS=OFF
CMAKE_ARGS += -DURIPARSER_BUILD_TESTS=OFF

include ../../mk/spksrc.cross-cmake.mk
