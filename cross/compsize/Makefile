PKG_NAME = compsize
PKG_VERS = 1.5
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/kilobyte/compsize/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = cross/btrfs-progs

# Although 32-bit builds may work, only 64-bit models support Btrfs.
REQUIRE_64BIT = 1

HOMEPAGE = https://github.com/kilobyte/compsize/blob/master/README.md
COMMENT = btrfs: find compression type/ratio on a file or set of files.
LICENSE = GPLv2+

CONFIGURE_TARGET = nop
INSTALL_TARGET = compsize_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: compsize_install
compsize_install:
	@install -d $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(WORK_DIR)/$(PKG_DIR)/compsize $(STAGING_INSTALL_PREFIX)/bin/compsize
