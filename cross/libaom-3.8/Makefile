PKG_NAME = libaom
# Max version compatible due to >= 3.9.0
# CHANGELOG: Documented minimum required SIMD support: SSE4.1 on x86
PKG_VERS = 3.8.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://storage.googleapis.com/aom-releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://aomedia.googlesource.com/aom/
COMMENT  = AOMedia Video 1 (AV1) is an open, royalty-free video coding format designed for video transmissions over the Internet.
LICENSE  = Royalty-free

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

# Set working directory
PKG_WORK_DIR = $(WORK_DIR)/$(PKG_NAME)_$(PKG_VERS)-build

CMAKE_USE_NASM = 1

# libaom specific cmake options
CMAKE_ARGS += -DCONFIG_AV1_ENCODER=1

CMAKE_ARGS += -DENABLE_TESTS=0
CMAKE_ARGS += -DENABLE_DOCS=0
CMAKE_ARGS += -DAOM_EXTRA_C_FLAGS=-O
CMAKE_ARGS += -DAOM_EXTRA_CXX_FLAGS=-O

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
CMAKE_ARGS += -DAOM_TARGET_CPU=arm
endif

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
CMAKE_ARGS += -DAOM_TARGET_CPU=arm
CMAKE_ARGS += -DENABLE_NEON=OFF
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CMAKE_ARGS += -DAOM_TARGET_CPU=arm64
ifeq ($(call version_lt, $(TCVERSION), 7.0),1)
CMAKE_ARGS += -DENABLE_NEON=OFF
endif
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
CMAKE_ARGS += -DAOM_TARGET_CPU=ppc
# avoid error: AltiVec and SPE instructions cannot coexist
CMAKE_ARGS += -DENABLE_VSX=0
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CMAKE_ARGS += -DAOM_TARGET_CPU=x86_64
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
CMAKE_ARGS += -DAOM_TARGET_CPU=x86
endif

include ../../mk/spksrc.cross-cmake.mk

# Fix compilation with newer compilers
# Flags to be added to CMake toolchain file
ifeq ($(call version_ge, $(TC_GCC), 7.5),1)
ADDITIONAL_CXXFLAGS += -D_GLIBCXX_USE_C99 -D_GLIBCXX_USE_C99_MATH
endif
