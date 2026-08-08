PKG_NAME = icingaweb2
PKG_VERS = 2.14.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Icinga/icingaweb2/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = icingaweb2-$(PKG_VERS)

DEPENDS = cross/icinga-php-library cross/icinga-php-thirdparty cross/icingaweb2-module-monitoring cross/icingaweb2-module-director cross/icingaweb2-module-incubator

HOMEPAGE = https://icinga.com/
COMMENT  = Icinga Web 2 is a powerful PHP framework for web applications that comes in a clean and reduced design.
LICENSE  = GPL-3.0-only

INSTALL_TARGET = icingaweb2_install

include ../../mk/spksrc.cross-install.mk

.PHONY: icingaweb2_install
icingaweb2_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/icingaweb2
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/icingaweb2
