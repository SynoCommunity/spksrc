PKG_NAME = zstd
PKG_VERS = 1.5.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/facebook/zstd/releases/download/v${PKG_VERS}
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/xz cross/lz4

HOMEPAGE = https://facebook.github.io/zstd/
COMMENT  = Zstandard is a fast compression algorithm, providing high compression ratios.
LICENSE  = GPLv2/BSD

MESON_BASE_DIR = $(WORK_DIR)/$(PKG_DIR)/build/meson
#CMAKE_BASE_DIR = $(WORK_DIR)/$(PKG_DIR)/build/cmake

include ../../mk/spksrc.common.mk

ifeq ($(call version_lt, ${TC_GCC}, 5),1)  
ADDITIONAL_CFLAGS = -std=gnu99
endif

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
ADDITIONAL_LDFLAGS = -lrt 
endif

include ../../mk/spksrc.cross-meson.mk
