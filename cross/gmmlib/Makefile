PKG_NAME = gmmlib
PKG_VERS = 20.1.1
PKG_EXT = tar.gz
PKG_DIST_NAME = intel-$(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/gmmlib/archive
PKG_DIR = $(PKG_NAME)/build

DEPENDS += cross/libva

HOMEPAGE = https://github.com/intel/gmmlib
COMMENT  = Intel Graphics Memory Management Library provides device specific and buffer management for the Intel Graphics Compute Runtime for OpenCL and the Intel Media Driver for VAAPI.
LICENSE  = MIT

POST_EXTRACT_TARGET = gmmlib_custom_post_extract
CONFIGURE_TARGET = gmmlib_custom_configure
COMPILE_TARGET = gmmlib_custom_compile
INSTALL_TARGET = gmmlib_custom_install

CMAKE_ARGS = -DBUILD_TYPE=release
CMAKE_ARGS += -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)
CMAKE_ARGS += -DCMAKE_CROSSCOMPILING=TRUE
CMAKE_ARGS += -DCMAKE_SYSTEM_NAME=Linux
CMAKE_ARGS += -DCMAKE_C_COMPILER=$(TC_PATH)$(TC_PREFIX)gcc
CMAKE_ARGS += -DCMAKE_CXX_COMPILER=$(TC_PATH)$(TC_PREFIX)g++
CMAKE_ARGS += -DCMAKE_BUILD_TYPE=Release
CMAKE_ARGS += -DRUN_TEST_SUITE=OFF
CMAKE_ARGS += -DCMAKE_INSTALL_RPATH=$(INSTALL_PREFIX)/lib
CMAKE_ARGS += -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE
CMAKE_ARGS += -DCMAKE_C_FLAGS=" -fPIC"
CMAKE_ARGS += -DCMAKE_CXX_FLAGS="-std=c++11"
CMAKE_ARGS += -DCMAKE_BUILD_WITH_INSTALL_RPATH=TRUE
CMAKE_ARGS += -DTHREADS_PTHREAD_ARG=2

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH), $(x86_ARCHES)),$(ARCH))
CMAKE_ARGS += -DARCH=32
endif

ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
CMAKE_ARGS += -DARCH=64
endif

# Set working directory
#PKG_WORK_DIR = $(WORK_DIR)/$(PKG_DIR)/build


.PHONY: gmmlib_custom_post_extract

gmmlib_custom_post_extract:
	cd $(WORK_DIR) && mv $(PKG_NAME)-intel-$(PKG_NAME)-$(PKG_VERS) $(PKG_NAME) && mkdir $(PKG_NAME)/build

.PHONY: gmmlib_custom_configure

gmmlib_custom_configure:
	$(RUN) cmake $(CMAKE_ARGS) ..

.PHONY: gmmlib_custom_compile

gmmlib_custom_compile: 
	$(RUN) $(MAKE) $(COMPILE_MAKE_OPTIONS) $(MAKE_ARGS)

.PHONY: gmmlib_custom_install

gmmlib_custom_install: 
	$(RUN) $(MAKE) install $(MAKE_ARGS) DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)
	$(RUN) cp igdgmm.pc $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/pkgconfig/
