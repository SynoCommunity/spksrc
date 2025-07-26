PKG_NAME = zap2epg
PKG_VERS = 3.4
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/th0ma7/tv_grab_zap2epg/archive/refs/tags
PKG_DIR = tv_grab_zap2epg-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/edit4ever/script.module.zap2epg
COMMENT  = zap2epg will generate an xmltv.xml file for USA/Canada TV lineups using zap2it source
LICENSE  = GPLv3

INSTALL_TARGET = zap2epg_install

include ../../mk/spksrc.install-resources.mk

.PHONY: zap2epg_install
zap2epg_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/tv_grab_zap2epg $(STAGING_INSTALL_PREFIX)/bin
	install -m 750 -d $(STAGING_INSTALL_PREFIX)/var/epggrab/conf
	install -m 640 $(WORK_DIR)/$(PKG_DIR)/zap2epg.xml $(STAGING_INSTALL_PREFIX)/var/epggrab/conf
