PKG_NAME = OctoPrint
PKG_VERS = 1.2.9
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/foosel/OctoPrint/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://octoprint.org/
COMMENT  = OctoPrint is a so called host software for 3D printers that controls your 3D printer and sends it the actual commands to do its job.
LICENSE  = AGPLv3

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = octoprint_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: octoprint_install
octoprint_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/OctoPrint
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/OctoPrint
