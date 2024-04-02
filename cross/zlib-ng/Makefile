PKG_NAME = zlib-ng
PKG_VERS = 2.1.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/zlib-ng/zlib-ng/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

CMAKE_ARGS += -DZLIB_ENABLE_TESTS=OFF
CMAKE_ARGS += -DZLIBNG_ENABLE_TESTS=OFF
CMAKE_ARGS += -DWITH_GTEST=OFF

HOMEPAGE = https://github.com/zlib-ng/zlib-ng
COMMENT  = zlib replacement with optimizations for "next generation" systems.
LICENSE  = zlib-license

include ../../mk/spksrc.cross-cmake.mk
