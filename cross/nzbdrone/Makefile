PKG_NAME = NzbDrone
PKG_BRANCH = master
PKG_VERS = 2.0.0.1397
PKG_LANG = mono
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME).$(PKG_BRANCH).$(PKG_VERS).$(PKG_LANG).$(PKG_EXT)
PKG_DIST_SITE = http://update.nzbdrone.com/v2/master/mono
PKG_DIR = $(PKG_NAME)

DEPENDS = 

HOMEPAGE = http://nzbdrone.com
COMMENT  = NZBDrone is a PVR for newsgroup users. It can monitor multiple RSS feeds for new episodes of your favourite shows and will grab, sorts and renames them. It can also be configured to automatically upgrade the quality of files already downloaded if a better quality format becomes available.
LICENSE  =

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)

