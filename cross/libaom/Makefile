PKG_NAME = libaom
PKG_VERS = v3.3.0
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = 87460cef80fb03def7d97df1b47bad5432e5e2e4
# Tag v3.3.0: 87460cef80fb03def7d97df1b47bad5432e5e2e4
# Tag v3.2.0: 287164de79516c25c8c84fd544f67752c170082a
# Tag v3.1.0: 33aff8586e35ffe385637f6aa2c991858c0fb58e
# Tag v3.0.0: d853caa2ab62d161e5edf344ffee7b597449dc0d
PKG_DIST_SITE = https://aomedia.googlesource.com/aom
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS =

HOMEPAGE = https://aomedia.googlesource.com/aom/
COMMENT  = AOMedia Video 1 (AV1) is an open, royalty-free video coding format designed for video transmissions over the Internet.
LICENSE  = Royalty-free

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

# Set working directory
PKG_WORK_DIR = $(WORK_DIR)/$(PKG_NAME)_$(PKG_VERS)-build

CMAKE_USE_NASM = 1
CMAKE_USE_NINJA = 1

include ../../mk/spksrc.cross-cmake.mk

# libaom specific cmake options
CMAKE_ARGS += -DCONFIG_AV1_ENCODER=1

# Disable tests
CMAKE_ARGS += -DENABLE_TESTS=0

# Fix compilation with newer compilers
# Flags to be added to CMake toolchain file
ifeq ($(call version_ge, ${TC_GCC}, 7.5),1)
ADDITIONAL_CXXFLAGS += -D_GLIBCXX_USE_C99 -D_GLIBCXX_USE_C99_MATH
endif

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
CMAKE_ARGS += -DAOM_TARGET_CPU=arm
endif

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
CMAKE_ARGS += -DAOM_TARGET_CPU=arm
CMAKE_ARGS += -DENABLE_NEON=OFF
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CMAKE_ARGS += -DAOM_TARGET_CPU=arm64
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
