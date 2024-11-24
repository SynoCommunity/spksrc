PKG_NAME = ps3netsrv
PKG_VERS = 20240709
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/aldostools/ps3netsrv/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = ps3netsrv-$(PKG_VERS)/

DEPENDS =

HOMEPAGE = https://github.com/aldostools/webMAN-MOD
COMMENT = Allows PlayStation®3 content to be loaded from network.
LICENSE = GPLv3

CONFIGURE_TARGET = nop
INSTALL_TARGET = ps3netsrv_install

COMPILE_MAKE_OPTIONS = -f Makefile.linux

include ../../mk/spksrc.cross-cc.mk

.PHONY: ps3netsrv_install
ps3netsrv_install:
		@mkdir -p $(STAGING_INSTALL_PREFIX)/bin
		@install -m 755 $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME) $(STAGING_INSTALL_PREFIX)/bin/
