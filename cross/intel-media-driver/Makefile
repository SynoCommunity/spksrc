PKG_NAME = intel-media
PKG_VERS = 21.1.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/media-driver/archive
PKG_DIR = media-driver-$(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/gmmlib
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

HOMEPAGE = https://github.com/intel/media-driver
COMMENT  = The Intel Media Driver for VAAPI is a new VA-API (Video Acceleration API) user mode driver supporting hardware accelerated decoding, encoding, and video post processing for GEN based graphics hardware.
LICENSE  = MIT

CMAKE_USE_DESTDIR = 0

include ../../mk/spksrc.cross-cmake.mk

# intel-media-driver specific args
# for succesfull build
CMAKE_ARGS += -DCMAKE_INSTALL_PREFIX=$(WORK_DIR)/install/$(INSTALL_PREFIX)
CMAKE_ARGS += -DCMAKE_C_FLAGS=-Wno-error=delete-incomplete
CMAKE_ARGS += -DCMAKE_CXX_FLAGS=-std=c++11
CMAKE_ARGS += -DMEDIA_RUN_TEST_SUITE=OFF
CMAKE_ARGS += -Wno-dev
