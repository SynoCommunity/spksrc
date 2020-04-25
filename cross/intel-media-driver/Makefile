PKG_NAME = intel-media
PKG_VERS = 20.1.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/media-driver/archive
PKG_DIR = media-driver

DEPENDS += cross/gmmlib cross/libva-utils
UNSUPPORTED_ARCHS = $(ARM_ARCHES) $(PPC_ARCHES) $(x86_ARCHES)

HOMEPAGE = https://github.com/intel/media-driver
COMMENT  = The Intel Media Driver for VAAPI is a new VA-API (Video Acceleration API) user mode driver supporting hardware accelerated decoding, encoding, and video post processing for GEN based graphics hardware.
LICENSE  = MIT

POST_EXTRACT_TARGET = intel-media_custom_post_extract
CONFIGURE_TARGET = intel-media_custom_configure
COMPILE_TARGET = intel-media_custom_compile
INSTALL_TARGET = intel-media_custom_install


CMAKE_ARGS = -DCMAKE_BUILD_TYPE=Release
CMAKE_ARGS += -DBUILD_TYPE=release
#CMAKE_ARGS += -DMEDIA_VERSION="19.2.1"
CMAKE_ARGS += -DENABLE_KERNELS=ON
CMAKE_ARGS += -DMEDIA_BUILD_FATAL_WARNINGS=OFF
CMAKE_ARGS += -DENABLE_NONFREE_KERNELS=ON
CMAKE_ARGS += -DBUILD_CMRTLIB=ON
CMAKE_ARGS += -DLIBVA_INSTALL_PATH="$(INSTALL_DIR)$(INSTALL_PREFIX)"
CMAKE_ARGS += -DLIBVA_LIBRARY_PATH="$(INSTALL_DIR)$(INSTALL_PREFIX)/lib"
CMAKE_ARGS += -DCMAKE_INSTALL_FULL_LIBDIR="$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib"
CMAKE_ARGS += -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)
CMAKE_ARGS += -DCMAKE_CROSSCOMPILING=TRUE
CMAKE_ARGS += -DCMAKE_SYSTEM_NAME=Linux
CMAKE_ARGS += -DCMAKE_C_COMPILER=$(TC_PATH)$(TC_PREFIX)gcc
CMAKE_ARGS += -DCMAKE_CXX_COMPILER=$(TC_PATH)$(TC_PREFIX)g++
CMAKE_ARGS += -DCMAKE_C_FLAGS="-L$(INSTALL_DIR)$(INSTALL_PREFIX)/lib"
CMAKE_ARGS += -DCMAKE_CXX_FLAGS="-std=c++14 -I$(INSTALL_DIR)$(INSTALL_PREFIX)/include"
CMAKE_ARGS += -DMEDIA_RUN_TEST_SUITE=OFF
CMAKE_ARGS += -DCMAKE_INSTALL_RPATH="$(INSTALL_PREFIX)/lib"
CMAKE_ARGS += -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE
CMAKE_ARGS += -DCMAKE_BUILD_WITH_INSTALL_RPATH=TRUE
CMAKE_ARGS += -DCMAKE_PREFIX_PATH="$(INSTALL_DIR)$(INSTALL_PREFIX)"
ENV += LIBVA_DRIVER_NAME=iHD
CMAKE_ARGS += -Wno-dev


include ../../mk/spksrc.cross-cc.mk


ifeq ($(findstring $(ARCH), $(x86_ARCHES)),$(ARCH))
CMAKE_ARGS += -DARCH=32
endif

ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
CMAKE_ARGS += -DARCH=64
endif

#ifeq ($(findstring $(ARCH), 'broadwell'),$(ARCH))
#CMAKE_ARGS += -DGEN8=ON
#CMAKE_ARGS += -DGEN9=OFF
#CMAKE_ARGS += -DGEN10=OFF
#CMAKE_ARGS += -DGEN11=OFF
#CMAKE_ARGS += -DGEN12=OFF
#endif

#ifeq ($(findstring $(ARCH), 'apollolake'),$(ARCH))
#CMAKE_ARGS += -DGEN8=ON
#CMAKE_ARGS += -DGEN9=ON
#CMAKE_ARGS += -DGEN10=OFF
#CMAKE_ARGS += -DGEN11=OFF
#CMAKE_ARGS += -DGEN12=OFF
#endif

#ifeq ($(findstring $(ARCH), 'denverton'),$(ARCH))
#CMAKE_ARGS += -DGEN8=OFF
#CMAKE_ARGS += -DGEN9=ON
#CMAKE_ARGS += -DGEN10=OFF
#CMAKE_ARGS += -DGEN11=OFF
#CMAKE_ARGS += -DGEN12=OFF
#endif

# Set working directory
#PKG_WORK_DIR = $(WORK_DIR)/$(PKG_DIR)/build

.PHONY: intel-media_custom_post_extract
intel-media_custom_post_extract:
	cd $(WORK_DIR) && mv media-driver-$(PKG_NAME)-$(PKG_VERS) $(PKG_DIR) && mkdir build_media

.PHONY: intel-media_custom_configure
intel-media_custom_configure: 
	$(RUN) && cd ../build_media &&  cmake $(CMAKE_ARGS) ../media-driver 


.PHONY: intel-media_custom_compile
intel-media_custom_compile: 
	$(RUN) && cd ../build_media && $(MAKE) $(COMPILE_MAKE_OPTIONS) $(MAKE_ARGS)


.PHONY: intel-media_custom_install
intel-media_custom_install: 
	$(RUN) && cd ../build_media && $(MAKE) install DESTDIR=$(INSTALL_DIR)
