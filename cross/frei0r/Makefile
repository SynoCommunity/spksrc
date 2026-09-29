PKG_NAME = frei0r
PKG_VERS = 3.6.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/dyne/frei0r/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/freetype cross/cairo

HOMEPAGE = https://frei0r.dyne.org/
COMMENT  = Frei0r is a minimalistic plugin API for video effects.
LICENSE  = GPL-2.0

# Needs gcc >= 7.5: needs C++17, i.e. gcc 7 or newer.
MIN_GCC_VERSION = 7.5

CONFIGURE_ARGS  = -DCMAKE_BUILD_TYPE=Release
CONFIGURE_ARGS += -DURIPARSER_BUILD_DOCS=OFF
CONFIGURE_ARGS += -DURIPARSER_BUILD_TESTS=OFF
# OpenCV and gavl are required unless disabled since 3.x (they were optional before)
CONFIGURE_ARGS += -DWITHOUT_OPENCV=ON
CONFIGURE_ARGS += -DWITHOUT_GAVL=ON
# shadert0y needs OpenGL/EGL, not available on headless NAS (patches/001)
CONFIGURE_ARGS += -DWITHOUT_OPENGL=ON

include ../../mk/spksrc.cross-cmake.mk
