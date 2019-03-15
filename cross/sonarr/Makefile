PKG_NAME = NzbDrone
PKG_VERS = 2.0.0.5301
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME).master.$(PKG_VERS).mono.$(PKG_EXT)
PKG_DIST_SITE = http://download.sonarr.tv/v2/master/mono
PKG_DIR = NzbDrone

DEPENDS =

HOMEPAGE = https://sonarr.tv
COMMENT  = Sonarr is a PVR for newsgroup users. It can monitor multiple RSS feeds for new episodes of your favourite shows and will grab, sorts and rename them. It can also be configured to automatically upgrade the quality of files already downloaded if a better quality format becomes available.
LICENSE  = GNU GPL v3

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)
