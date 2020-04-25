PKG_NAME = intel-mediasdk
PKG_VERS = 20.1.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Intel-Media-SDK/MediaSDK/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS += cross/intel-media-driver
UNSUPPORTED_ARCHS = $(ARM_ARCHES) $(PPC_ARCHES) $(x86_ARCHES)

ifneq ($(strip $(PKG_LINK_TYPE)),static)
PATCHES = $(sort $(wildcard patches/002*.patch))
else
PATCHES = $(sort $(wildcard patches/*.patch))
endif


HOMEPAGE = http://mediasdk.intel.com
COMMENT  = Intel Media SDK provides a plain C API to access hardware-accelerated video decode, encode and filtering on Intel® Gen graphics hardware platforms. Implementation written in C++ 11 with parts in C-for-Media (CM).
LICENSE  = MIT

POST_EXTRACT_TARGET = intel-mediasdk_post_extract
CONFIGURE_TARGET = intel-mediasdk_custom_configure
COMPILE_TARGET = intel-mediasdk_custom_compile
INSTALL_TARGET = intel-mediasdk_custom_install

CMAKE_ARGS += -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)
CMAKE_ARGS += -DCMAKE_CROSSCOMPILING=TRUE
CMAKE_ARGS += -DCMAKE_SYSTEM_NAME=Linux
CMAKE_ARGS += -DCMAKE_C_COMPILER=$(TC_PATH)$(TC_PREFIX)gcc
CMAKE_ARGS += -DCMAKE_CXX_COMPILER=$(TC_PATH)$(TC_PREFIX)g++
CMAKE_ARGS += -DCMAKE_CXX_FLAGS="-std=c++11 -I$(INSTALL_DIR)$(INSTALL_PREFIX)/include -Wl,-L$(INSTALL_DIR)$(INSTALL_PREFIX)/lib"
CMAKE_ARGS += -DCMAKE_C_FLAGS="-I$(INSTALL_DIR)$(INSTALL_PREFIX)/include -Wl,-L$(INSTALL_DIR)$(INSTALL_PREFIX)/lib"
CMAKE_ARGS += -DCMAKE_INSTALL_RPATH="$(INSTALL_PREFIX)/lib"
CMAKE_ARGS += -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE
CMAKE_ARGS += -DCMAKE_BUILD_WITH_INSTALL_RPATH=TRUE
CMAKE_ARGS += -Wno-dev
ENV += LIBVA_DRIVERS_PATH=$(INSTALL_DIR)$(INSTALL_PREFIX)/lib/dri
ENV += LIBVA_DRIVER_NAME=iHD
CMAKE_ARGS += -DENABLE_OPENCL=OFF
CMAKE_ARGS += -DBUILD_RUNTIME=ON
CMAKE_ARGS += -DBUILD_TOOLS=OFF
CMAKE_ARGS += -DBUILD_SAMPLES=OFF
CMAKE_ARGS += -DBUILD_TESTS=OFF
CMAKE_ARGS += -DBUILD_DISPATCHER=ON
CMAKE_ARGS += -DBUILD_TUTORIALS=OFF
CMAKE_ARGS += -DENABLE_TEXTLOG=OFF
CMAKE_ARGS += -DENABLE_STAT=OFF
CMAKE_ARGS += -DENABLE_ITT=OFF 
CMAKE_ARGS += -DCMAKE_INSTALL_FULL_LIBDIR="$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib"
CMAKE_ARGS += -DBUILD_TYPE=release

ifneq ($(strip $(HANDBRAKE)),)
CMAKE_ARGS += -DENABLE_X11_DRI3=OFF
CMAKE_ARGS += -DENABLE_X11=OFF
endif

include ../../mk/spksrc.cross-cc.mk

ifneq ($(strip $(PKG_LINK_TYPE)),static)
PATCHES = $(sort $(wildcard patches/002*.patch))
else
PATCHES = $(sort $(wildcard patches/*.patch))
endif

ifeq ($(findstring $(ARCH), $(x86_ARCHES)),$(ARCH))
CMAKE_ARGS += -DARCH=32
endif

ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
CMAKE_ARGS += -DARCH=64
endif

# Set working directory
#PKG_WORK_DIR = $(WORK_DIR)/$(PKG_DIR)/build


.PHONY: intel-mediasdk_post_extract

intel-mediasdk_post_extract:
	cd $(WORK_DIR) && mv MediaSDK-$(PKG_NAME)-$(PKG_VERS) $(PKG_NAME)-$(PKG_VERS)  && mkdir $(PKG_NAME)-$(PKG_VERS)/build

.PHONY: intel-mediasdk_custom_configure

intel-mediasdk_custom_configure: 
	$(RUN) && cd build && cmake $(CMAKE_ARGS) ..

.PHONY: intel-mediasdk_custom_compile

intel-mediasdk_custom_compile: 
	$(RUN) && cd build && $(MAKE) $(COMPILE_MAKE_OPTIONS) $(MAKE_ARGS)

.PHONY: intel-mediasdk_custom_install

intel-mediasdk_custom_install: 
	$(RUN) && cd build && $(MAKE) install DESTDIR=$(INSTALL_DIR)

