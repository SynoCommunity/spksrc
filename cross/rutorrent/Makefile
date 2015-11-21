PKG_NAME = ruTorrent
PKG_VERS = 3.7
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://dl.bintray.com/novik65/generic
PKG_DIR = $(PKG_NAME)

DEPENDS = 

HOMEPAGE = http://code.google.com/p/rutorrent/
COMMENT  = Yet another web front-end for rTorrent.
LICENSE  = GPLv3

EXTRACT_PATH = $(WORK_DIR)
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	mv $(WORK_DIR)/ruTorrent-master $(WORK_DIR)/$(PKG_NAME)
	rm $(WORK_DIR)/$(PKG_NAME)/.htaccess
	chmod -R u+w $(WORK_DIR)/$(PKG_DIR)
	cp src/favicon.ico $(WORK_DIR)/$(PKG_DIR)
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/rutorrent
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/rutorrent
