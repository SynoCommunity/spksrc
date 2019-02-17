PKG_NAME = webgrabplus
PKG_VERS = 2.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)_V$(PKG_VERS)_install.$(PKG_EXT)
PKG_DIST_SITE = http://www.webgrabplus.com/sites/default/files/download/SW/V$(PKG_VERS).0
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.webgrabplus.com/
COMMENT  = WebGrab Plus is a multi-site incremental xmltv epg grabber. It collects tv-program guide data from selected tvguide sites for your favourite channels.
LICENSE  = Freeware

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = webgrab_custom_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: webgrab_custom_install

webgrab_custom_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
	tar -cf - -C $(WORK_DIR)/.wg++ . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
