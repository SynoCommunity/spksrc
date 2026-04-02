PKG_NAME = icinga-director
PKG_VERS = 1.11.8
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Icinga/icingaweb2-module-director/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = icingaweb2-module-director-$(PKG_VERS)

DEPENDS = cross/icinga-php-library cross/icingaweb2-module-incubator

HOMEPAGE = https://icinga.com/products/director/
COMMENT  = Icinga Director - Configuration frontend for Icinga 2
LICENSE  = GPLv2

INSTALL_TARGET = icinga_director_install

include ../../mk/spksrc.install-resources.mk

.PHONY: icinga_director_install
icinga_director_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/icingaweb2/modules
	cp -r $(WORK_DIR)/$(PKG_DIR) $(STAGING_INSTALL_PREFIX)/share/icingaweb2/modules/director
