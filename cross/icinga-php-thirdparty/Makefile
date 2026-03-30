PKG_NAME = icinga-php-thirdparty
PKG_VERS = 0.12.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Icinga/icinga-php-thirdparty/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/Icinga/icinga-php-thirdparty
COMMENT  = Third-party PHP libraries for Icinga Web 2 including Zend Framework 1
LICENSE  = Multiple

INSTALL_TARGET = icinga_php_thirdparty_install

include ../../mk/spksrc.install-resources.mk

.PHONY: icinga_php_thirdparty_install
icinga_php_thirdparty_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/icinga-php/vendor/vendor
	cp -r $(WORK_DIR)/$(PKG_DIR)/vendor/* $(STAGING_INSTALL_PREFIX)/share/icinga-php/vendor/vendor/
	cp $(WORK_DIR)/$(PKG_DIR)/composer.json $(STAGING_INSTALL_PREFIX)/share/icinga-php/vendor/
	cp $(WORK_DIR)/$(PKG_DIR)/composer.lock $(STAGING_INSTALL_PREFIX)/share/icinga-php/vendor/
	cp $(WORK_DIR)/$(PKG_DIR)/VERSION $(STAGING_INSTALL_PREFIX)/share/icinga-php/vendor/
	cp $(WORK_DIR)/$(PKG_DIR)/AssetLoader.php $(STAGING_INSTALL_PREFIX)/share/icinga-php/vendor/
	cp -r $(WORK_DIR)/$(PKG_DIR)/asset $(STAGING_INSTALL_PREFIX)/share/icinga-php/vendor/
	cp -r $(WORK_DIR)/$(PKG_DIR)/patches $(STAGING_INSTALL_PREFIX)/share/icinga-php/vendor/
	cp $(WORK_DIR)/$(PKG_DIR)/LICENSE $(STAGING_INSTALL_PREFIX)/share/icinga-php/vendor/
	cp $(WORK_DIR)/$(PKG_DIR)/README.md $(STAGING_INSTALL_PREFIX)/share/icinga-php/vendor/
