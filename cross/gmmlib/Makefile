PKG_NAME = gmmlib
PKG_VERS = 19.4.1
PKG_EXT = tar.gz
PKG_DIST_NAME = intel-$(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/gmmlib/archive
PKG_DIR = $(PKG_NAME)-intel-$(PKG_NAME)-$(PKG_VERS)

DEPENDS += cross/libva

HOMEPAGE = https://github.com/intel/gmmlib
COMMENT  = Intel Graphics Memory Management Library provides device specific and buffer management for the Intel Graphics Compute Runtime for OpenCL and the Intel Media Driver for VAAPI.
LICENSE  = MIT

CONFIGURE_TARGET = gmmlib_custom_configure
COMPILE_TARGET = gmmlib_custom_compile
INSTALL_TARGET = gmmlib_custom_install

CMAKE_ARGS = -DBUILD_TYPE=release
CMAKE_ARGS += -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)
CMAKE_ARGS += -DCMAKE_CROSSCOMPILING=TRUE
CMAKE_ARGS += -DCMAKE_SYSTEM_NAME=Linux
CMAKE_ARGS += -DCMAKE_C_COMPILER=$(TC_PATH)$(TC_PREFIX)gcc
CMAKE_ARGS += -DCMAKE_CXX_COMPILER=$(TC_PATH)$(TC_PREFIX)g++
CMAKE_ARGS += -DCMAKE_BUILD_TYPE=None
CMAKE_ARGS += -DRUN_TEST_SUITE=OFF

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH), $(x86_ARCHES)),$(ARCH))
CMAKE_ARGS += -DARCH=32
endif

ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
CMAKE_ARGS += -DARCH=64
endif

# Set working directory
PKG_WORK_DIR = $(WORK_DIR)/$(PKG_DIR)/build

.PHONY: gmmlib_custom_configure

gmmlib_custom_configure: 
	mkdir --parents $(PKG_WORK_DIR)/build
	cd $(PKG_WORK_DIR) && env $(ENV) cmake $(CMAKE_ARGS) ..

.PHONY: gmmlib_custom_compile

gmmlib_custom_compile: 
	cd $(PKG_WORK_DIR) && env $(ENV) $(MAKE)

.PHONY: gmmlib_custom_install

gmmlib_custom_install: 
	cd $(PKG_WORK_DIR) && env $(ENV) $(MAKE) install DESTDIR=$(INSTALL_DIR)
