PKG_NAME = SVT-AV1
PKG_VERS = 0.8.3
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/OpenVisualCloud/SVT-AV1/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
# Set an appropriate filename as release files on github doesn't
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)

DEPENDS =
OPTIONAL_DEPENDS = native/nasm cross/libnuma

HOMEPAGE = https://github.com/OpenVisualCloud/SVT-AV1
COMMENT  = The Scalable Video Technology for AV1 (SVT-AV1 Encoder and Decoder) is an AV1-compliant encoder/decoder library core.
LICENSE  = SPDX short identifier: BSD-2-Clause-Patent

UNSUPPORTED_ARCHS = $(ARM5_ARCHES) $(PPC_ARCHES)

CONFIGURE_TARGET = svt-av1_custom_configure
COMPILE_TARGET = svt-av1_custom_compile
INSTALL_TARGET = svt-av1_custom_install

NASM_PATH = $(WORK_DIR)/../../../native/nasm/work-native/install/usr/local/bin

CMAKE_ARGS = -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)
CMAKE_ARGS += -DCMAKE_CROSSCOMPILING=TRUE
CMAKE_ARGS += -DCMAKE_SYSTEM_NAME=Linux
CMAKE_ARGS += -DCMAKE_C_COMPILER=$(TC_PATH)$(TC_PREFIX)gcc
CMAKE_ARGS += -DCMAKE_CXX_COMPILER=$(TC_PATH)$(TC_PREFIX)g++
CMAKE_ARGS += -DCMAKE_INSTALL_RPATH=$(INSTALL_PREFIX)/lib
CMAKE_ARGS += -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE
CMAKE_ARGS += -DCMAKE_BUILD_WITH_INSTALL_RPATH=TRUE
CMAKE_ARGS += -DCONFIG_AV1_ENCODER=1 -DBUILD_SHARED_LIBS=1

include ../../mk/spksrc.cross-cc.mk

# Set working directory
PKG_WORK_DIR = $(WORK_DIR)/$(PKG_NAME)_$(PKG_VERS)-build

ifeq ($(findstring $(ARCH), $(ARM5_ARCHES)),$(ARCH))
CMAKE_ARGS += -DCROSS_COMPILE_ARM=ON -DENABLE_ASSEMBLY=OFF
CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=armv5 -DAOM_TARGET_CPU=arm
endif

ifeq ($(findstring $(ARCH), $(ARM7_ARCHES)),$(ARCH))
CMAKE_ARGS += -DCMAKE_CXX_FLAGS=-fPIC -DCROSS_COMPILE_ARM=ON -DENABLE_ASSEMBLY=OFF
CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=armv7 -DAOM_TARGET_CPU=arm
endif

ifeq ($(findstring $(ARCH), $(ARM8_ARCHES)),$(ARCH))
CMAKE_ARGS += -DCMAKE_CXX_FLAGS=-fPIC -DCROSS_COMPILE_ARM=ON -DENABLE_ASSEMBLY=OFF
CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=aarch64 -DAOM_TARGET_CPU=arm64
endif

ifeq ($(findstring $(ARCH), $(PPC_ARCHES)),$(ARCH))
CMAKE_ARGS += -DCMAKE_C_FLAGS=-maltivec -DENABLE_ALTIVEC=OFF -DCPU_POWER8=OFF
CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=ppc64 -DAOM_TARGET_CPU=ppc
endif

ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
DEPENDS += native/nasm cross/libnuma
ENV += PATH=$(NASM_PATH):$$PATH
ENV += AS=$(NASM_PATH)/nasm
CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=x86_64 -DAOM_TARGET_CPU=x86_64
endif

ifeq ($(findstring $(ARCH), $(x86_ARCHES)),$(ARCH))
DEPENDS += native/nasm cross/libnuma
ENV += PATH=$(NASM_PATH):$$PATH
ENV += AS=$(NASM_PATH)/nasm
CMAKE_ARGS += -DENABLE_ASSEMBLY=OFF -DCMAKE_SYSTEM_PROCESSOR=x86
CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=x86 -DAOM_TARGET_CPU=x86
endif

.PHONY: svt-av1_custom_configure
svt-av1_custom_configure: 
	$(RUN) rm -rf CMakeCache.txt CMakeFiles
	$(RUN) mkdir --parents $(PKG_WORK_DIR)
	cd $(PKG_WORK_DIR) && env $(ENV) cmake $(CMAKE_ARGS) $(WORK_DIR)/$(PKG_DIR)

.PHONY: svt-av1_custom_compile
svt-av1_custom_compile: 
	cd $(PKG_WORK_DIR) && env $(ENV) $(MAKE)

.PHONY: svt-av1_custom_install
svt-av1_custom_install: 
	cd $(PKG_WORK_DIR) && env $(ENV) $(MAKE) install DESTDIR=$(INSTALL_DIR)
