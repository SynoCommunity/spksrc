PKG_NAME = libaom
PKG_VERS = 3.13.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://storage.googleapis.com/aom-releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://aomedia.googlesource.com/aom/
COMMENT  = AOMedia Video 1 (AV1) is an open, royalty-free video coding format designed for video transmissions over the Internet.
LICENSE  = Royalty-free

REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k

# Set working directory
PKG_WORK_DIR = $(WORK_DIR)/$(PKG_NAME)_$(PKG_VERS)-build

# libaom specific cmake options
CMAKE_ARGS += -DCONFIG_AV1_ENCODER=1
CMAKE_ARGS += -DENABLE_TESTS=0
CMAKE_ARGS += -DENABLE_DOCS=0
CMAKE_ARGS += -DAOM_EXTRA_C_FLAGS=-O
CMAKE_ARGS += -DAOM_EXTRA_CXX_FLAGS=-O

# Adjusting debug flags for libaom compatibility
# Debug mode with -O0 fails to build neon and x86 asm
ifeq ($(strip $(GCC_DEBUG_INFO)),1)
  GCC_DEBUG_FLAGS = -ggdb3 -g3 -O1 -gz
endif

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
CMAKE_ARGS += -DAOM_TARGET_CPU=arm
CMAKE_ARGS += -DENABLE_NEON=OFF
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CMAKE_ARGS += -DAOM_TARGET_CPU=arm64
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CMAKE_ARGS += -DAOM_TARGET_CPU=x86_64
CMAKE_ARGS += -DENABLE_NASM=ON
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
CMAKE_ARGS += -DAOM_TARGET_CPU=x86
CMAKE_ARGS += -DENABLE_NASM=ON
endif

include ../../mk/spksrc.cross-cmake.mk

# Fix compilation with newer compilers
# Flags to be added to CMake toolchain file
ifeq ($(call version_ge, $(TC_GCC), 7.5),1)
ADDITIONAL_CXXFLAGS += -D_GLIBCXX_USE_C99 -D_GLIBCXX_USE_C99_MATH
endif
