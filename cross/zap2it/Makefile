PKG_NAME = zap2it
PKG_VERS = 20210519
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/daniel-widrick/zap2it-GuideScraping/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-GuideScraping-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/daniel-widrick/zap2it-GuideScraping
COMMENT  = Take TV listings from zap2it and convert them to xmltv for use with applications such as Jellyfin/Emby
LICENSE  = MIT

INSTALL_TARGET = zap2it_install

include ../../mk/spksrc.install-resources.mk

.PHONY: zap2it_install
zap2it_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/zap2it-GuideScrape.py $(STAGING_INSTALL_PREFIX)/bin
	@sed -i '1 i\#!/usr/bin/env python3' $(STAGING_INSTALL_PREFIX)/bin/zap2it-GuideScrape.py
	install -m 750 -d $(STAGING_INSTALL_PREFIX)/etc
	install -m 640 $(WORK_DIR)/$(PKG_DIR)/zap2itconfig.ini.dist $(STAGING_INSTALL_PREFIX)/etc/zap2itconfig.ini
