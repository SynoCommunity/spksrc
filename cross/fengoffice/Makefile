PKG_NAME = fengoffice
PKG_VERS = 2.5.1.2
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/opengoo/files/$(PKG_NAME)/$(PKG_NAME)_$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.fengoffice.com
COMMENT  = Feng Office is a Collaboration Platform and Project Management System.
LICENSE  = AGPL

EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = fengoffice_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: fengoffice_install
fengoffice_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/fengoffice
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/fengoffice
	install -m 644 src/install_helper.php $(STAGING_INSTALL_PREFIX)/share/fengoffice/public/install/install_helper.php
