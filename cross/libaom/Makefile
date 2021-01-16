PKG_NAME = libaom
PKG_VERS = v2.0.1
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = b52ee6d44adaef8a08f6984390de050d64df9faa
# Tag v2.0.1: b52ee6d44adaef8a08f6984390de050d64df9faa
# Tag v2.0.0: bb35ba9148543f22ba7d8642e4fbd29ae301f5dc
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

include ../../mk/spksrc.cross-cmake.mk

# libaom specific cmake options
CMAKE_ARGS += -DCONFIG_AV1_ENCODER=1

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
CMAKE_ARGS += -DAOM_TARGET_CPU=arm
endif

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
CMAKE_ARGS += -DAOM_TARGET_CPU=arm
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
