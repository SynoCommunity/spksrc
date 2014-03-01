PKG_NAME = plugins
PKG_VERS = 3.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://dl.bintray.com/novik65/generic
PKG_DIR = $(PKG_NAME)

DEPENDS = 

HOMEPAGE = http://code.google.com/p/rutorrent/
COMMENT  = All plugins for ruTorrent
LICENSE  = GPLv3

EXTRACT_PATH = $(WORK_DIR)
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/rutorrent/plugins
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/rutorrent/plugins
