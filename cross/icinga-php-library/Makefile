PKG_NAME = icinga-php-library
PKG_VERS = 0.14.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Icinga/icinga-php-library/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/Icinga/icinga-php-library
COMMENT  = Icinga PHP Library (IPL) for Icinga Web 2 modules
LICENSE  = MIT

INSTALL_TARGET = icinga_php_library_install

include ../../mk/spksrc.install-resources.mk

.PHONY: icinga_php_library_install
icinga_php_library_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/icinga-php
	cp -r $(WORK_DIR)/$(PKG_DIR) $(STAGING_INSTALL_PREFIX)/share/icinga-php/ipl
