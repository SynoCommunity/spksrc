PKG_NAME = level-zero
PKG_VERS = 1.9.4
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/oneapi-src/level-zero/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/intel-gmmlib
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

HOMEPAGE = https://github.com/oneapi-src/level-zero
COMMENT  = oneAPI Level Zero API is provides direct-to-metal interfaces to offload accelerator devices
LICENSE  = MIT

include ../../mk/spksrc.cross-cmake.mk

# intel-media-driver specific args
# for succesfull build
CMAKE_ARGS += -Wno-dev
