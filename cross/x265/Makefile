PKG_NAME = x265
PKG_VERS = 4.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://bitbucket.org/multicoreware/x265_git/downloads
PKG_DIR = $(PKG_NAME)_$(PKG_VERS)

HOMEPAGE = http://x265.org/
COMMENT  = x265 is an open source HEVC encoder.
LICENSE  = GPLv2

PRE_CONFIGURE_TARGET = x265_pre_configure
PRE_COMPILE_TARGET = x265_pre_compile

CMAKE_SOURCE_DIR = source

# Build directories for default, 12 and 10 bit depth
CMAKE_BUILD_DIR = $(WORK_DIR)/$(PKG_DIR)/buildAll
CMAKE_BUILD_12B = $(WORK_DIR)/$(PKG_DIR)/build12bit
CMAKE_BUILD_10B = $(WORK_DIR)/$(PKG_DIR)/build10bit

# additional cmake args for the build of 10 and 12 bit depth libraries
CMAKE_ARGS_BITLIB += -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF
CMAKE_ARGS_BITLIB += -DENABLE_SHARED=OFF -DENABLE_CLI=OFF -DEXTRA_LINK_FLAGS="-ldl"
# provide cmake toolchain path when building bitlibs
CMAKE_ARGS_BITLIB += -DCMAKE_TOOLCHAIN_FILE=$(CMAKE_TOOLCHAIN_FILE_PKG)

# additional cmake args for the final multilib build
ADDITIONAL_CMAKE_ARGS += -DEXTRA_LIB="x265_main10.a;x265_main12.a" -DEXTRA_LINK_FLAGS="-ldl -L."
ADDITIONAL_CMAKE_ARGS += -DLINKED_10BIT=ON -DLINKED_12BIT=ON -DENABLE_SHARED=ON

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
ifeq ($(call version_ge, $(TCVERSION), 7.1),1)
# asm code is now compatible with arm64/aarch64 for DSM >= 7.1 (except i8mm instructions)
CMAKE_ARGS += -DENABLE_NEON_I8MM=OFF
else
# https://bitbucket.org/multicoreware/x265_git/issues/549/fail-to-build-for-aarch64-and-armhf
CMAKE_ARGS += -DENABLE_ASSEMBLY=OFF
endif
endif

ifeq ($(findstring $(ARCH),$(32bit_ARCHS)),$(ARCH))
# asm code for HIGH_BIT_DEPTH is not compatible with 32-bit archs
CMAKE_ARGS_BITLIB += -DENABLE_ASSEMBLY=OFF
endif


# Fixes:
#    https://github.com/SynoCommunity/spksrc/issues/5314
#    https://github.com/SynoCommunity/spksrc/issues/6597
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
CMAKE_ARGS += -DENABLE_PIC=ON
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS) $(x64_ARCHS)),$(ARCH))
CMAKE_ARGS += -DCMAKE_ASM_NASM_FLAGS=-w-macro-params-legacy
endif


include ../../mk/spksrc.cross-cmake.mk

# gcc version above 4.8 required to support hdr10plus
ifeq ($(call version_le, $(TC_GCC), 4.8),1)
PLIST_TRANSFORM = sed -e '/:lib\/libhdr10plus.so/d'
else
CMAKE_ARGS += -DENABLE_HDR10_PLUS=ON
PLIST_TRANSFORM = cat
endif

.PHONY: x265_pre_configure
x265_pre_configure: $(CMAKE_TOOLCHAIN_FILE_PKG)
	@$(MSG) Configure 12BIT libraries
	$(RUN_CMAKE) cmake -S $(WORK_DIR)/$(PKG_DIR)/source -B $(CMAKE_BUILD_12B) $(CMAKE_ARGS) $(CMAKE_ARGS_BITLIB) -DMAIN12=ON -G Ninja
	@$(MSG) Configure 10BIT libraries
	$(RUN_CMAKE) cmake -S $(WORK_DIR)/$(PKG_DIR)/source -B $(CMAKE_BUILD_10B) $(CMAKE_ARGS) $(CMAKE_ARGS_BITLIB) -G Ninja

.PHONY: x265_pre_compile
x265_pre_compile:
	@$(MSG) Build 12BIT libraries
	@$(RUN) ninja -C $(CMAKE_BUILD_12B)
	@$(MSG) Build 10BIT libraries
	@$(RUN) ninja -C $(CMAKE_BUILD_10B)
	@$(RUN) ln -sf $(CMAKE_BUILD_12B)/libx265.a $(CMAKE_BUILD_DIR)/libx265_main12.a
	@$(RUN) ln -sf $(CMAKE_BUILD_10B)/libx265.a $(CMAKE_BUILD_DIR)/libx265_main10.a
