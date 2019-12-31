PKG_NAME = intel-media
PKG_VERS = 19.4.0r
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/media-driver/archive
PKG_DIR = media-driver-$(PKG_NAME)-$(PKG_VERS)

DEPENDS += cross/gmmlib

HOMEPAGE = https://github.com/intel/media-driver
COMMENT  = The Intel Media Driver for VAAPI is a new VA-API (Video Acceleration API) user mode driver supporting hardware accelerated decoding, encoding, and video post processing for GEN based graphics hardware.
LICENSE  = MIT

CONFIGURE_TARGET = intel-media_custom_configure
COMPILE_TARGET = intel-media_custom_compile
INSTALL_TARGET = intel-media_custom_install

CMAKE_ARGS = -DBUILD_TYPE=release
CMAKE_ARGS += -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)
CMAKE_ARGS += -DCMAKE_CROSSCOMPILING=TRUE
CMAKE_ARGS += -DCMAKE_SYSTEM_NAME=Linux
CMAKE_ARGS += -DCMAKE_C_COMPILER=$(TC_PATH)$(TC_PREFIX)gcc
CMAKE_ARGS += -DCMAKE_CXX_COMPILER=$(TC_PATH)$(TC_PREFIX)g++
CMAKE_ARGS += -DCMAKE_BUILD_TYPE=None
CMAKE_ARGS += -DRUN_TEST_SUITE=ON

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH), $(x86_ARCHES)),$(ARCH))
CMAKE_ARGS += -DARCH=32
endif

ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
CMAKE_ARGS += -DARCH=64
endif

# Set working directory
PKG_WORK_DIR = $(WORK_DIR)/$(PKG_DIR)/build

.PHONY: intel-media_custom_configure

intel-media_custom_configure: 
	mkdir --parents $(PKG_WORK_DIR)/build
	cd $(PKG_WORK_DIR) && env $(ENV) cmake $(CMAKE_ARGS) ..

.PHONY: intel-media_custom_compile

intel-media_custom_compile: 
	cd $(PKG_WORK_DIR) && env $(ENV) $(MAKE)

.PHONY: intel-media_custom_install

intel-media_custom_install: 
	cd $(PKG_WORK_DIR) && env $(ENV) $(MAKE) install DESTDIR=$(INSTALL_DIR)
