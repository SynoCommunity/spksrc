PKG_NAME = nextcloud
PKG_VERS = 32.0.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.nextcloud.com/server/releases
PKG_DIR = $(PKG_NAME)

DEPENDS =

HOMEPAGE = https://nextcloud.com/
COMMENT  = Nextcloud is a self-hosted productivity platform that lets you access files, calendars, contacts and more via web or WebDAV, with a rich ecosystem of apps and integrations.
LICENSE  = AGPLv3

INSTALL_TARGET = nextcloud_install

include ../../mk/spksrc.install-resources.mk

.PHONY: nextcloud_install
nextcloud_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
