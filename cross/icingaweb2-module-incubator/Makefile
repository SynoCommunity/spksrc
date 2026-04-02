PKG_NAME = incubator
PKG_VERS = 0.22.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Icinga/icingaweb2-module-incubator/archive/refs/tags
PKG_DIR = icingaweb2-module-incubator-$(PKG_VERS)

DEPENDS = cross/icinga-php-library cross/icinga-php-thirdparty

HOMEPAGE = https://github.com/Icinga/icingaweb2-module-incubator
COMMENT  = Incubator provides bleeding-edge libraries for Icinga Web 2
LICENSE  = GPL-2.0

INSTALL_TARGET = incubator_install

include ../../mk/spksrc.install-resources.mk

.PHONY: incubator_install
incubator_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/icingaweb2/modules
	cp -r $(WORK_DIR)/$(PKG_DIR) $(STAGING_INSTALL_PREFIX)/share/icingaweb2/modules/incubator
