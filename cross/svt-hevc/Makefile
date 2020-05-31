PKG_NAME = SVT-HEVC
PKG_VERS = 1.4.3
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/OpenVisualCloud/SVT-HEVC/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
# Set an appropriate filename as release files on github doesn't
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)

DEPENDS = 
OPTIONAL_DEPENDS = native/nasm cross/libnuma

HOMEPAGE = https://github.com/OpenVisualCloud/SVT-HEVC
COMMENT  = Scalable Video Technology (SVT) is a software-based video coding technology that is highly optimized for Intel® Xeon® processors allowing to spread video encoding processing across multiple processors to achieve a real advantage of processing efficiency.
LICENSE  = SPDX short identifier: BSD-2-Clause-Patent

# SVT-HEVC is only supported on x86_64 Intel platforms
UNSUPPORTED_ARCHS = $(ARM5_ARCHES) $(ARM7_ARCHES) $(ARM8_ARCHES) $(PPC_ARCHES) $(x86_ARCHES)

CONFIGURE_TARGET = svt_hevc_custom_configure
COMPILE_TARGET = svt_hevc_custom_compile
INSTALL_TARGET = svt_hevc_custom_install

NASM_PATH = $(WORK_DIR)/../../../native/nasm/work-native/install/usr/local/bin

CMAKE_ARGS = -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)
CMAKE_ARGS += -DCMAKE_CROSSCOMPILING=TRUE
CMAKE_ARGS += -DCMAKE_SYSTEM_NAME=Linux
CMAKE_ARGS += -DCMAKE_C_COMPILER=$(TC_PATH)$(TC_PREFIX)gcc
CMAKE_ARGS += -DCMAKE_INSTALL_RPATH=$(INSTALL_PREFIX)/lib
CMAKE_ARGS += -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE
CMAKE_ARGS += -DCMAKE_BUILD_WITH_INSTALL_RPATH=TRUE
CMAKE_ARGS += -DCMAKE_BUILD_TYPE=Release
CMAKE_ARGS += -DBUILD_SHARED_LIBS=ON

include ../../mk/spksrc.cross-cc.mk

# Set working directory
PKG_WORK_DIR = $(WORK_DIR)/$(PKG_NAME)_$(PKG_VERS)-build

ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
DEPENDS += native/nasm cross/libnuma
ENV += PATH=$(NASM_PATH):$$PATH
ENV += AS=$(NASM_PATH)/nasm
CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=x86_64
endif

.PHONY: svt_hevc_custom_configure
svt_hevc_custom_configure: 
	$(RUN) rm -rf CMakeCache.txt CMakeFiles
	$(RUN) mkdir --parents $(PKG_WORK_DIR)
	cd $(PKG_WORK_DIR) && env $(ENV) cmake $(CMAKE_ARGS) $(WORK_DIR)/$(PKG_DIR)

.PHONY: svt_hevc_custom_compile
svt_hevc_custom_compile: 
	cd $(PKG_WORK_DIR) && env $(ENV) $(MAKE)

.PHONY: svt_hevc_custom_install
svt_hevc_custom_install: 
	cd $(PKG_WORK_DIR) && env $(ENV) $(MAKE) install DESTDIR=$(INSTALL_DIR)
