PKG_NAME = gracenote2epg
PKG_VERS = 1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/th0ma7/tv_grab_gracenote2epg/archive/refs/tags
PKG_DIR = tv_grab_$(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/th0ma7/tv_grab_gracenote2epg
COMMENT  = A modular Python implementation for downloading TV guide data from tvlistings.gracenote.com with intelligent caching and TVheadend integration.
LICENSE  = GPLv3

INSTALL_TARGET = gracenote2epg_install

include ../../mk/spksrc.install-resources.mk

.PHONY: gracenote2epg_install
gracenote2epg_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME).py $(STAGING_INSTALL_PREFIX)/bin
	@cd $(STAGING_INSTALL_PREFIX)/bin && ln -sf $(PKG_NAME).py tv_grab_$(PKG_NAME)
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin/$(PKG_NAME)
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME)/*.py $(STAGING_INSTALL_PREFIX)/bin/$(PKG_NAME)
	install -m 750 -d $(STAGING_INSTALL_PREFIX)/var/epggrab/$(PKG_NAME)/conf
	install -m 640 $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME).xml $(STAGING_INSTALL_PREFIX)/var/epggrab/$(PKG_NAME)/conf
