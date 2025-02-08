PKG_NAME = ruTorrent
PKG_VERS = 4.3.7
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Novik/ruTorrent/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/Novik/ruTorrent
COMMENT  = Yet another web front-end for rTorrent.
LICENSE  = GPLv3

EXTRACT_PATH = $(WORK_DIR)
INSTALL_TARGET = rutorrent_install

include ../../mk/spksrc.install-resources.mk

.PHONY: rutorrent_install
rutorrent_install:
	rm -f $(WORK_DIR)/$(PKG_DIR)/.htaccess
	chmod -R u+w $(WORK_DIR)/$(PKG_DIR)
	cp src/favicon.ico $(WORK_DIR)/$(PKG_DIR)
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/rutorrent
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/rutorrent
