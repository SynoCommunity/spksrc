PKG_NAME = nextcloud
PKG_VERS = 17.0.2
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.nextcloud.com/server/releases/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://nextcloud.com
COMMENT  = Nextcloud puts your data at your fingertips, under your control. Store your documents, calendar, contacts and photos on a server at home, at one of our providers or in a data center you trust.
LICENSE  = AGPLv3

EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/nextcloud
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/nextcloud
