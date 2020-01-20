PKG_NAME = intel-mediasdk
PKG_VERS = 19.4.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Intel-Media-SDK/MediaSDK/archive
PKG_DIR = MediaSDK-$(PKG_NAME)-$(PKG_VERS)

DEPENDS += cross/intel-media-driver
UNSUPPORTED_ARCHS = $(ARM_ARCHES) $(PPC_ARCHES) $(x86_ARCHES)

HOMEPAGE = http://mediasdk.intel.com
COMMENT  = Intel Media SDK provides a plain C API to access hardware-accelerated video decode, encode and filtering on Intel® Gen graphics hardware platforms. Implementation written in C++ 11 with parts in C-for-Media (CM).
LICENSE  = MIT

CONFIGURE_TARGET = intel-mediasdk_custom_configure
COMPILE_TARGET = intel-mediasdk_custom_compile
INSTALL_TARGET = intel-mediasdk_custom_install

CMAKE_ARGS = -DBUILD_TYPE=release
CMAKE_ARGS += -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)
CMAKE_ARGS += -DMFX_PLUGINS_DIR=$(INSTALL_PREFIX)/lib
CMAKE_ARGS += -DCMAKE_CROSSCOMPILING=TRUE
CMAKE_ARGS += -DCMAKE_SYSTEM_NAME=Linux
CMAKE_ARGS += -DCMAKE_C_COMPILER=$(TC_PATH)$(TC_PREFIX)gcc
CMAKE_ARGS += -DCMAKE_CXX_COMPILER=$(TC_PATH)$(TC_PREFIX)g++
CMAKE_ARGS += -DCMAKE_CXX_FLAGS='-std=c++11'
CMAKE_ARGS += -DBUILD_SAMPLES=OFF
CMAKE_ARGS += -DBUILD_TUTORIALS=OFF
CMAKE_ARGS += -Wno-dev

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH), $(x86_ARCHES)),$(ARCH))
CMAKE_ARGS += -DARCH=32
endif

ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
CMAKE_ARGS += -DARCH=64
endif

# Set working directory
PKG_WORK_DIR = $(WORK_DIR)/$(PKG_DIR)/build

.PHONY: intel-mediasdk_custom_configure

intel-mediasdk_custom_configure: 
	mkdir --parents $(PKG_WORK_DIR)/build
	cd $(PKG_WORK_DIR) && env $(ENV) cmake $(CMAKE_ARGS) ..

.PHONY: intel-mediasdk_custom_compile

intel-mediasdk_custom_compile: 
	cd $(PKG_WORK_DIR) && env $(ENV) $(MAKE)

.PHONY: intel-mediasdk_custom_install

intel-mediasdk_custom_install: 
	cd $(PKG_WORK_DIR) && env $(ENV) $(MAKE) install DESTDIR=$(INSTALL_DIR)
