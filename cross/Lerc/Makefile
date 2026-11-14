PKG_NAME = Lerc
PKG_VERS = 4.0.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Esri/lerc/archive/refs/tags
PKG_DIR = lerc-$(PKG_VERS)

HOMEPAGE = https://github.com/Esri/lerc
COMMENT  = Limited Error Raster Compression — open-source image/raster format
LICENSE  = Apache-2.0

CMAKE_ARGS = -DBUILD_SHARED_LIBS=ON
CMAKE_ARGS += -DBUILD_TOOLS=OFF
CMAKE_ARGS += -DBUILD_TESTING=OFF

include ../../mk/spksrc.cross-cmake.mk
