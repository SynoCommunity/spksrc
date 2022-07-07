PKG_NAME = Sonarr
PKG_VERS = 3.0.5.1144
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME).main.$(PKG_VERS).linux.$(PKG_EXT)
PKG_DIST_SITE = https://download.sonarr.tv/v3/main/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)

DEPENDS =

HOMEPAGE = https://sonarr.tv
COMMENT  = Sonarr is a PVR for newsgroup users. It can monitor multiple RSS feeds for new episodes of your favourite shows and will grab, sorts and rename them. It can also be configured to automatically upgrade the quality of files already downloaded if a better quality format becomes available.
LICENSE  = GNU GPL v3

INSTALL_TARGET = sonarr_install

include ../../mk/spksrc.install-resources.mk

.PHONY: sonarr_install
sonarr_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)
