PKG_NAME = x265
PKG_VERS = 3.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://bitbucket.org/multicoreware/x265_git/downloads
PKG_DIR = $(PKG_NAME)_$(PKG_VERS)

OPTIONAL_DEPENDS = native/nasm

HOMEPAGE = http://x265.org/
COMMENT  = x265 is an open source HEVC encoder.
LICENSE  = GPL

PRE_CONFIGURE_TARGET = x265_pre_configure
PRE_COMPILE_TARGET = x265_pre_compile

CMAKE_USE_NASM = 1
CMAKE_SOURCE_DIR = source

# Build directories for default, 12 and 10 bit depth
CMAKE_BUILD_DIR = $(WORK_DIR)/$(PKG_DIR)/buildAll
CMAKE_BUILD_12B = $(WORK_DIR)/$(PKG_DIR)/build12bit
CMAKE_BUILD_10B = $(WORK_DIR)/$(PKG_DIR)/build10bit

# additional cmake args for the build of 10 and 12 bit depth libraries
CMAKE_ARGS_BITLIB += -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF
CMAKE_ARGS_BITLIB += -DENABLE_SHARED=OFF -DENABLE_CLI=OFF -DEXTRA_LINK_FLAGS="-ldl"
# provide cmake toolchain path when building bitlibs
CMAKE_ARGS_BITLIB += -DCMAKE_TOOLCHAIN_FILE=$(CMAKE_TOOLCHAIN_PKG)

# additional cmake args for the final multilib build
ADDITIONAL_CMAKE_ARGS += -DEXTRA_LIB="x265_main10.a;x265_main12.a" -DEXTRA_LINK_FLAGS="-ldl -L."
ADDITIONAL_CMAKE_ARGS += -DLINKED_10BIT=ON -DLINKED_12BIT=ON -DENABLE_SHARED=ON

include ../../mk/spksrc.common.mk

# asm code for HIGH_BIT_DEPTH is not compatible with arm64/aarch64
# https://bitbucket.org/multicoreware/x265_git/issues/549/fail-to-build-for-aarch64-and-armhf
ifeq ($(findstring $(ARCH),$(ARM_ARCHS) $(PPC_ARCHS)),$(ARCH))
CMAKE_ARGS += -DENABLE_ASSEMBLY=OFF
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS) $(x64_ARCHS)),$(ARCH))
CMAKE_ARGS += -DCMAKE_ASM_NASM_FLAGS=-w-macro-params-legacy
endif

# asm code for HIGH_BIT_DEPTH is not compatible with 32-bit arch
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
CMAKE_ARGS_BITLIB += -DENABLE_ASSEMBLY=OFF
endif

include ../../mk/spksrc.cross-cmake.mk

# gcc version above 4.8 required to support hdr10plus
ifeq ($(call version_le, $(TC_GCC), 4.8),1)
PLIST_TRANSFORM = sed -e '/:lib\/libhdr10plus.so/d'
else
CMAKE_ARGS += -DENABLE_HDR10_PLUS=ON
PLIST_TRANSFORM = cat
endif

ifeq ($(call version_ge, $(TCVERSION), 7.0),1)
CMAKE_ARGS += -DCMAKE_CXX_FLAGS=-D_GLIBCXX_USE_C99_MATH
endif

# For ppc853x-4.3, disable atomics
ifeq ($(ARCH)-$(TCVERSION), ppc853x-4.3)
CMAKE_ARGS += -DNO_ATOMICS=ON
CMAKE_ARGS += -DCMAKE_CXX_FLAGS="-DSPKSRC_FIX_PPC853X_4_3"
endif

.PHONY: x265_pre_configure
x265_pre_configure: $(CMAKE_TOOLCHAIN_PKG)
	@$(MSG) Configure 12BIT libraries
	$(RUN) cmake -S $(WORK_DIR)/$(PKG_DIR)/source -B $(CMAKE_BUILD_12B) $(CMAKE_ARGS) $(CMAKE_ARGS_BITLIB) -DMAIN12=ON -G Ninja
	@$(MSG) Configure 10BIT libraries
	$(RUN) cmake -S $(WORK_DIR)/$(PKG_DIR)/source -B $(CMAKE_BUILD_10B) $(CMAKE_ARGS) $(CMAKE_ARGS_BITLIB) -G Ninja

.PHONY: x265_pre_compile
x265_pre_compile:
	@$(MSG) Build 12BIT libraries
	@$(RUN) ninja -C $(CMAKE_BUILD_12B)
	@$(MSG) Build 10BIT libraries
	@$(RUN) ninja -C $(CMAKE_BUILD_10B)
	@$(RUN) ln -sf $(CMAKE_BUILD_12B)/libx265.a $(CMAKE_BUILD_DIR)/libx265_main12.a
	@$(RUN) ln -sf $(CMAKE_BUILD_10B)/libx265.a $(CMAKE_BUILD_DIR)/libx265_main10.a
