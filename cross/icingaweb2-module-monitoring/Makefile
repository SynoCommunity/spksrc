PKG_NAME = icinga-monitoring
PKG_VERS = 2.12.6
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Icinga/icingaweb2-module-monitoring/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = icingaweb2-module-monitoring-$(PKG_VERS)

DEPENDS = cross/icinga-php-library cross/icinga-php-thirdparty

HOMEPAGE = https://icinga.com/
COMMENT  = Icinga monitoring module - IDO accessor and UI for your monitoring.
LICENSE  = GPL-3.0-only

INSTALL_TARGET = icinga_monitoring_install

include ../../mk/spksrc.cross-install.mk

.PHONY: icinga_monitoring_install
icinga_monitoring_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/icingaweb2/modules
	cp -r $(WORK_DIR)/$(PKG_DIR) $(STAGING_INSTALL_PREFIX)/share/icingaweb2/modules/monitoring
