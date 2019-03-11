PKG_NAME = emby
PKG_VERS = 4.0.2.0
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)server-netframework_$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/MediaBrowser/Emby.Releases/releases/download/${PKG_VERS}
PKG_DIR = emby

DEPENDS = 

HOMEPAGE = https://emby.media
COMMENT = Emby streams everything Your personal videos, music, photos, and live television in the palm of your hand.
LICENSE = GNU GPL v3

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

EXTRACT_PATH = $(WORK_DIR)/extract

include ../../mk/spksrc.cross-cc.mk

myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)
	tar -cf - -C $(EXTRACT_PATH) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)

