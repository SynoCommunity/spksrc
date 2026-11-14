PKG_NAME = libdeflate
PKG_VERS = 1.22
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ebiggers/libdeflate/archive/refs/tags
PKG_DIR = libdeflate-$(PKG_VERS)

HOMEPAGE = https://github.com/ebiggers/libdeflate
COMMENT  = Heavily optimized library for DEFLATE/zlib/gzip (de)compression
LICENSE  = MIT

CMAKE_ARGS = -DLIBDEFLATE_BUILD_STATIC_LIB=OFF
CMAKE_ARGS += -DLIBDEFLATE_BUILD_TESTS=OFF
CMAKE_ARGS += -DLIBDEFLATE_BUILD_GZIP=OFF

include ../../mk/spksrc.cross-cmake.mk
