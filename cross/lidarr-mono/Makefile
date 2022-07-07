PKG_NAME = Lidarr
PKG_VERS = 0.8.0.2042
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME).develop.$(PKG_VERS).linux.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Lidarr/Lidarr/releases/download/v$(PKG_VERS)
PKG_DIR = Lidarr

DEPENDS =

HOMEPAGE = https://lidarr.audio/
COMMENT  = Lidarr is a music collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new tracks from your favorite artists and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.
LICENSE  = GPLv3

INSTALL_TARGET = lidarr_install

include ../../mk/spksrc.install-resources.mk

lidarr_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)
