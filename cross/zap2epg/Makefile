PKG_NAME = zap2epg
PKG_VERS = 4.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/th0ma7/tv_grab_zap2epg/archive/refs/tags
PKG_DIR = tv_grab_zap2epg-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/th0ma7/tv_grab_zap2epg
COMMENT  = tv_grab_zap2epg will generate an xmltv.xml file for Canada/USA TV lineups by fetching channel list from tvheadend and downloading relevant entries from tvlistings.gracenote.com.
LICENSE  = GPLv3

INSTALL_TARGET = zap2epg_install

include ../../mk/spksrc.install-resources.mk

.PHONY: zap2epg_install
zap2epg_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/tv_grab_$(PKG_NAME) $(STAGING_INSTALL_PREFIX)/bin
	install -m 750 -d $(STAGING_INSTALL_PREFIX)/var/epggrab/$(PKG_NAME)/conf
	install -m 640 $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME).xml $(STAGING_INSTALL_PREFIX)/var/epggrab/$(PKG_NAME)/conf
