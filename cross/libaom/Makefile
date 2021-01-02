PKG_NAME = libaom
PKG_VERS = v2.0.0
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = bb35ba9148543f22ba7d8642e4fbd29ae301f5dc
# Tag v2.0.0: bb35ba9148543f22ba7d8642e4fbd29ae301f5dc
PKG_DIST_SITE = https://aomedia.googlesource.com/aom
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS = 

HOMEPAGE = https://aomedia.googlesource.com/aom/
COMMENT  = AOMedia Video 1 (AV1) is an open, royalty-free video coding format designed for video transmissions over the Internet.
LICENSE  = Royalty-free

UNSUPPORTED_ARCHS = $(ARM5_ARCHES) $(PPC_ARCHES)

# Set working directory
PKG_WORK_DIR = $(WORK_DIR)/$(PKG_NAME)_$(PKG_VERS)-build

CMAKE_USE_NASM = 1

include ../../mk/spksrc.cross-cmake.mk

# libaom specific cmake options
CMAKE_ARGS += -DCONFIG_AV1_ENCODER=1

ifeq ($(findstring $(ARCH), $(ARM5_ARCHES)),$(ARCH))
CMAKE_ARGS += -DAOM_TARGET_CPU=arm
endif

ifeq ($(findstring $(ARCH), $(ARM7_ARCHES)),$(ARCH))
CMAKE_ARGS += -DAOM_TARGET_CPU=arm
endif

ifeq ($(findstring $(ARCH), $(ARM8_ARCHES)),$(ARCH))
CMAKE_ARGS += -DAOM_TARGET_CPU=arm64
endif

ifeq ($(findstring $(ARCH), $(PPC_ARCHES)),$(ARCH))
CMAKE_ARGS += -DAOM_TARGET_CPU=ppc
endif

ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
CMAKE_ARGS += -DAOM_TARGET_CPU=x86_64
endif

ifeq ($(findstring $(ARCH), $(x86_ARCHES)),$(ARCH))
CMAKE_ARGS += -DAOM_TARGET_CPU=x86
endif
