PKG_NAME = libaom
PKG_VERS = 3.15.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://storage.googleapis.com/aom-releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://aomedia.googlesource.com/aom/
COMMENT  = AOMedia Video 1 (AV1) is an open, royalty-free video coding format designed for video transmissions over the Internet.
LICENSE  = Royalty-free

# Needs gcc >= 7.5: needs C++17, i.e. gcc 7 or newer.
MIN_GCC_VERSION = 7.5
# C11 static_assert in assert.h and sys/auxv.h (arm cpu detection) came with glibc 2.16
MIN_GLIBC_VERSION = 2.16

# Set working directory
PKG_WORK_DIR = $(WORK_DIR)/$(PKG_NAME)_$(PKG_VERS)-build

# libaom specific cmake options
CONFIGURE_ARGS += -DCONFIG_AV1_ENCODER=1
CONFIGURE_ARGS += -DENABLE_TESTS=0
CONFIGURE_ARGS += -DENABLE_DOCS=0
CONFIGURE_ARGS += -DAOM_EXTRA_C_FLAGS=-O
CONFIGURE_ARGS += -DAOM_EXTRA_CXX_FLAGS=-O

# Adjusting debug flags for libaom compatibility
# Debug mode with -O0 fails to build neon and x86 asm
ifeq ($(strip $(GCC_DEBUG_INFO)),1)
  GCC_DEBUG_FLAGS = -ggdb3 -g3 -O1 -gz
endif

include ../../mk/spksrc.common.mk

# ENABLE_NEON and ENABLE_VSX both default to ON (cmake/aom_config_defaults.cmake), and
# cmake/cpu.cmake acts on them for any AOM_TARGET_CPU matching ^arm or ppc. Neither is a
# compiler question, so MIN_GCC_VERSION cannot speak for them: the SIMD an arch actually
# has must be named here. Carried over from cross/libaom-3.8, which states all of this.

# ARMv5 (88f6281): armv5te has no NEON at all.
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
CONFIGURE_ARGS += -DAOM_TARGET_CPU=arm
CONFIGURE_ARGS += -DENABLE_NEON=OFF
endif

# ARMv7 hard float, and ARMv7L (hi3535) which is soft float: NEON uses the VFP register
# file, so neither gets it here. Without this, 3.15 fails on `unknown type name int16x4_t`.
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
CONFIGURE_ARGS += -DAOM_TARGET_CPU=arm
CONFIGURE_ARGS += -DENABLE_NEON=OFF
endif

# PowerPC e500v2 (qoriq, ppc853x) is SPE, not AltiVec/VSX -- gcc refuses the pair with
# "AltiVec and SPE instructions cannot coexist".
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
CONFIGURE_ARGS += -DAOM_TARGET_CPU=ppc
CONFIGURE_ARGS += -DENABLE_VSX=0
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CONFIGURE_ARGS += -DAOM_TARGET_CPU=arm64
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CONFIGURE_ARGS += -DAOM_TARGET_CPU=x86_64
CONFIGURE_ARGS += -DENABLE_NASM=ON
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
CONFIGURE_ARGS += -DAOM_TARGET_CPU=x86
CONFIGURE_ARGS += -DENABLE_NASM=ON
endif

include ../../mk/spksrc.cross-cmake.mk

# Fix compilation with newer compilers
# Flags to be added to CMake toolchain file
ifeq ($(call version_ge, $(TC_GCC), 7.5),1)
ADDITIONAL_CXXFLAGS += -D_GLIBCXX_USE_C99 -D_GLIBCXX_USE_C99_MATH
endif
