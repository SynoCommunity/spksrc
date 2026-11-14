PKG_NAME = duperemove
# 0.15.x uses statx, which DSM kernels do not implement.
PKG_VERS = 0.14.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/markfasheh/duperemove/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/glib cross/sqlite cross/libblkid cross/libmount cross/libuuid
BUILD_DEPENDS = cross/xxhash cross/libbsd

REQUIRE_64BIT = 1
MIN_GCC_VERSION = 4.8

HOMEPAGE = https://markfasheh.github.io/duperemove/duperemove.html
COMMENT = Tools for deduplicating files on Btrfs.
LICENSE = GPLv2

CONFIGURE_TARGET = nop
INSTALL_TARGET = duperemove_install

include ../../mk/spksrc.cross-cc.mk

COMPILE_ARGS += VERSION=$(PKG_VERS) IS_RELEASE=1

.PHONY: duperemove_install
duperemove_install:
	@install -d $(STAGING_INSTALL_PREFIX)/bin
	@for prog in duperemove hashstats btrfs-extent-same; do \
		install -m 755 $(WORK_DIR)/$(PKG_DIR)/$$prog $(STAGING_INSTALL_PREFIX)/bin/ ; \
	done
