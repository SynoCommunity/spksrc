PKG_NAME = OctoPrint
PKG_VERS = 1.7.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/OctoPrint/$(PKG_NAME)/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://octoprint.org/
COMMENT  = OctoPrint provides a snappy web interface for controlling consumer 3D printers.
LICENSE  = AGPLv3

INSTALL_TARGET = octoprint_install

include ../../mk/spksrc.install-resources.mk

.PHONY: octoprint_install
octoprint_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/OctoPrint
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/OctoPrint
