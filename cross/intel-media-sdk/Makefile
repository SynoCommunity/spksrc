PKG_NAME = intel-mediasdk
PKG_VERS = 21.1.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Intel-Media-SDK/MediaSDK/archive
PKG_DIR = MediaSDK-$(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/intel-media-driver
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

HOMEPAGE = http://mediasdk.intel.com
COMMENT  = Intel Media SDK provides a plain C API to access hardware-accelerated video decode, encode and filtering on Intel® Gen graphics hardware platforms. Implementation written in C++ 11 with parts in C-for-Media (CM).
LICENSE  = MIT

include ../../mk/spksrc.cross-cmake.mk

# intel-media-sdk specific args
# for succesfull build
CMAKE_ARGS += -DMFX_PLUGINS_DIR=$(INSTALL_PREFIX)/lib
CMAKE_ARGS += -DCMAKE_CXX_FLAGS='-std=c++11'
CMAKE_ARGS += -DBUILD_SAMPLES=OFF
CMAKE_ARGS += -DBUILD_TUTORIALS=OFF
CMAKE_ARGS += -Wno-dev
