PKG_NAME = tdu
PKG_VERS = 1.36
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/josephpaul0/tdu/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/go

HOMEPAGE = https://github.com/josephpaul0/tdu
COMMENT  = Top Disk Usage. You want to know what is using all your disk space? This command-line tool estimates the disk space occupied by all files in a given path. It displays a sorted list of the biggest items. The estimation method is similar to the 'du -skx' command from GNU Coreutils package.
LICENSE  = GPLv2

INSTALL_TARGET = tdu_install

GO_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)
GO_BUILD_ARGS += -ldflags '-s -w'

include ../../mk/spksrc.cross-go.mk

.PHONY: tdu_install
tdu_install:
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/bin/
	@$(RUN) ; install -m 755 tdu $(STAGING_INSTALL_PREFIX)/bin/
