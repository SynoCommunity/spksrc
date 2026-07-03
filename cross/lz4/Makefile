PKG_NAME = lz4
PKG_VERS = 1.10.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/lz4/lz4/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/lz4/lz4
COMMENT  = LZ4 is lossless compression algorithm, providing compression speed at 400 MB/s per core, scalable with multi-cores CPU.
LICENSE  = BSD

MESON_BASE_DIR = $(WORK_DIR)/$(PKG_DIR)/build/meson

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
ADDITIONAL_LDFLAGS += -lrt
endif

ifeq ($(GCC_DEBUG_INFO),1)
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
ADDITIONAL_CFLAGS = -std=c99
endif
endif

include ../../mk/spksrc.cross-meson.mk
