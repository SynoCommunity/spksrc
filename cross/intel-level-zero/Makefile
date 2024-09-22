PKG_NAME = level-zero
PKG_VERS = 1.17.42
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/oneapi-src/level-zero/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/intel-gmmlib
REQUIRED_MIN_DSM = 7
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

HOMEPAGE = https://github.com/oneapi-src/level-zero
COMMENT  = This project is part of the larger oneAPI project and contains copies of the Level Zero Specification API C/C++ header files, Level Zero Loader, Level Zero Validation Layer and Level Zero Tracing Layer
LICENSE  = MIT

include ../../mk/spksrc.cross-cmake.mk
