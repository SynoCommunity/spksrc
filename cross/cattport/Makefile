PKG_NAME = cattport
PKG_VERS = 1.0.0-beta.3
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/morcatt-labs/cattport/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/morcatt-labs/cattport
COMMENT  = Docker services and links as tiles in the DSM main menu.
LICENSE  = GPLv3

INSTALL_TARGET = cattport_install

include ../../mk/spksrc.cross-install.mk

.PHONY: cattport_install
cattport_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)
	cp -R $(WORK_DIR)/$(PKG_DIR)/src/package/lib $(WORK_DIR)/$(PKG_DIR)/src/package/ui $(STAGING_INSTALL_PREFIX)/
	chmod 755 $(STAGING_INSTALL_PREFIX)/ui/api.cgi
