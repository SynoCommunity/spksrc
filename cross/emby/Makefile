PKG_NAME = emby
PKG_VERS = 3.0.5724.5
PKG_EXT = zip
PKG_DIST_NAME = MediaBrowser-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/MediaBrowser/MediaBrowser.Releases/raw/master/Server
PKG_DIR = emby

DEPENDS = 

HOMEPAGE = http://emby.media/
COMMENT  = Emby streams everything Your personal videos, music, photos, and live television in the palm of your hand.
LICENSE  = GPL

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)

include ../../mk/spksrc.cross-cc.mk

myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)
