PKG_NAME = x265
PKG_VERS = 3.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://bitbucket.org/multicoreware/x265_git/downloads
PKG_DIR = $(PKG_NAME)_$(PKG_VERS)/source

OPTIONAL_DEPENDS = native/nasm

HOMEPAGE = http://x265.org/
COMMENT  = x265 is an open source HEVC encoder.
LICENSE  = GPL

CONFIGURE_TARGET = x265_configure

CMAKE_ARGS  = -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)
CMAKE_ARGS += -DCMAKE_CROSSCOMPILING=TRUE
CMAKE_ARGS += -DCMAKE_SYSTEM_NAME=Linux
CMAKE_ARGS += -DCMAKE_C_COMPILER=$(TC_PATH)$(TC_PREFIX)gcc
CMAKE_ARGS += -DCMAKE_CXX_COMPILER=$(TC_PATH)$(TC_PREFIX)g++
CMAKE_ARGS += -DCMAKE_INSTALL_RPATH=$(INSTALL_PREFIX)/lib
CMAKE_ARGS += -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE
CMAKE_ARGS += -DCMAKE_BUILD_WITH_INSTALL_RPATH=TRUE
CMAKE_ARGS += -DENABLE_LIBNUMA=OFF

# additional cmake args for the build of 10 and 12 bit depth libraries
CMAKE_BITLIB_ARGS =

# additional cmake args for the final multilib build
CMAKE_MULTILIB_ARGS =

include ../../mk/spksrc.cross-cc.mk

# gcc version above 4.8 required to support hdr10plus
PLIST_TRANSFORM = sed -e '/:lib\/libhdr10plus.so/d'
ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
CMAKE_ARGS += -DENABLE_HDR10_PLUS=ON
PLIST_TRANSFORM = cat
endif

ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
CMAKE_ARGS += -DCMAKE_CXX_FLAGS=-D_GLIBCXX_USE_C99_MATH
endif

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=armv5
CMAKE_ARGS += -DCROSS_COMPILE_ARM=ON
CMAKE_ARGS += -DENABLE_ASSEMBLY=OFF
endif

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=armv7
CMAKE_ARGS += -DCROSS_COMPILE_ARM=ON
CMAKE_ARGS += -DCMAKE_CXX_FLAGS=-fPIC
CMAKE_ARGS += -DENABLE_ASSEMBLY=OFF
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=aarch64
CMAKE_ARGS += -DCROSS_COMPILE_ARM=ON
CMAKE_ARGS += -DCMAKE_CXX_FLAGS=-fPIC
CMAKE_ARGS += -DENABLE_ASSEMBLY=OFF
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=ppc64
CMAKE_ARGS += -DCMAKE_CXX_FLAGS=-m32
CMAKE_ARGS += -DENABLE_ALTIVEC=OFF
CMAKE_ARGS += -DCPU_POWER8=OFF
CMAKE_ARGS += -DENABLE_ASSEMBLY=OFF
CMAKE_ARGS += -DCMAKE_CXX_FLAGS=-fPIC
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS) $(x64_ARCHS)),$(ARCH))
BUILD_DEPENDS = native/nasm
NASM_PATH = $(realpath $(WORK_DIR)/../../../native/nasm/work-native/install/usr/local/bin)
ENV += PATH=$(NASM_PATH):$$PATH
ENV += AS=$(NASM_PATH)/nasm
CMAKE_ARGS += -DNASM_EXECUTABLE=$(NASM_PATH)/nasm

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=x86_64 -DCMAKE_ASM_NASM_FLAGS=-w-macro-params-legacy
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=x86
# asm code for HIGH_BIT_DEPTH is not compatible with 32 bit arch
CMAKE_BITLIB_ARGS += -DENABLE_ASSEMBLY=OFF
CMAKE_MULTILIB_ARGS += -DCMAKE_ASM_NASM_FLAGS=-w-macro-params-legacy
endif
endif

# For ppc853x-4.3, disable atomics
ifeq ($(ARCH)-$(TCVERSION), ppc853x-4.3)
CMAKE_ARGS += -DNO_ATOMICS=ON
CMAKE_ARGS += -DCMAKE_CXX_FLAGS="-DSPKSRC_FIX_PPC853X_4_3"
endif


.PHONY: $(PKG_DIR)/libx265_main12.a $(PKG_DIR)/libx265_main10.a x265_configure

# First create specific static libraries with build options for 12 and 10 bit depth
PKG_WORK_DIR = $(WORK_DIR)/$(PKG_NAME)_$(PKG_VERS)
PKG_BUILD_12BIT = $(PKG_WORK_DIR)/build12bit
PKG_BUILD_10BIT = $(PKG_WORK_DIR)/build10bit

CMAKE_BITLIB_ARGS += -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF
CMAKE_BITLIB_ARGS += -DENABLE_SHARED=OFF -DENABLE_CLI=OFF -DEXTRA_LINK_FLAGS="-ldl"

$(PKG_DIR)/libx265_main12.a:
	mkdir --parents $(PKG_BUILD_12BIT)
	@$(MSG) Configure for 12BIT libraries
	cd $(PKG_BUILD_12BIT) && cmake $(CMAKE_ARGS) $(CMAKE_BITLIB_ARGS) -DMAIN12=ON ../source
	@$(MSG) Build 12BIT libraries
	cd $(PKG_BUILD_12BIT) && $(MAKE) $(COMPILE_MAKE_OPTIONS)
	@$(RUN) ln -sf $(PKG_BUILD_12BIT)/libx265.a libx265_main12.a

$(PKG_DIR)/libx265_main10.a:
	@$(MSG) Configure for 10BIT libraries
	mkdir --parents $(PKG_BUILD_10BIT)
	cd $(PKG_BUILD_10BIT) && cmake $(CMAKE_ARGS) $(CMAKE_BITLIB_ARGS) ../source
	@$(MSG) Build 10BIT libraries
	cd $(PKG_BUILD_10BIT) && $(MAKE) $(COMPILE_MAKE_OPTIONS)
	@$(RUN) ln -sf $(PKG_BUILD_10BIT)/libx265.a libx265_main10.a

# Aggregate them all together in default 8 bit depth build
CMAKE_MULTILIB_ARGS += -DEXTRA_LIB="x265_main10.a;x265_main12.a" -DEXTRA_LINK_FLAGS="-ldl -L."
CMAKE_MULTILIB_ARGS += -DLINKED_10BIT=ON -DLINKED_12BIT=ON -DENABLE_SHARED=ON

x265_configure: $(PKG_DIR)/libx265_main12.a $(PKG_DIR)/libx265_main10.a
	@$(RUN) cmake $(CMAKE_ARGS) $(CMAKE_MULTILIB_ARGS) .
