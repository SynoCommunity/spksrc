PKG_NAME = zap2epg
PKG_VERS = 3.0
PKG_EXT = tar.gz
PKG_GIT_HASH = 65336f7e6d24c32df392aadc0c9140429bbbe1d7
PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/th0ma7/script.module.zap2epg/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = script.module.zap2epg-$(PKG_GIT_HASH)

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
	install -m 640 $(WORK_DIR)/$(PKG_DIR)/epggrab/conf/zap2epg.xml $(STAGING_INSTALL_PREFIX)/var/epggrab/conf
