PKG_NAME = ps3netsrv
PKG_VERS = 1.47.15
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/aldostools/webMAN-MOD/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = webMAN-MOD-$(PKG_VERS)/_Projects_/$(PKG_NAME)

DEPENDS =

HOMEPAGE = https://github.com/aldostools/webMAN-MOD
COMMENT = Allows PS3 content to be loaded from network
LICENSE = GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS =

CONFIGURE_TARGET = nop
INSTALL_TARGET = ps3netsrv_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: ps3netsrv_install
ps3netsrv_install:
		@mkdir -p $(STAGING_INSTALL_PREFIX)/bin
		@install -m 755 $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME) $(STAGING_INSTALL_PREFIX)/bin/
