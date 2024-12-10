PKG_NAME = owncloud
PKG_VERS = 10.15.0
PKG_DATE = 20240724
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-complete-$(PKG_DATE).$(PKG_EXT)
PKG_DIST_SITE = https://download.owncloud.com/server/stable
PKG_DIR = $(PKG_NAME)

DEPENDS =

HOMEPAGE = https://owncloud.com/
COMMENT  = ownCloud gives you universal access to your files through a web interface or WebDAV. It also provides a platform to easily view & sync your contacts, calendars and bookmarks across all your devices and enables basic editing right on the web. Installation has minimal server requirements, doesn’t need special permissions and is quick. ownCloud is extendable via a simple but powerful API for applications and plugins.
LICENSE  = AGPLv3

INSTALL_TARGET = owncloud_install

include ../../mk/spksrc.install-resources.mk

.PHONY: owncloud_install
owncloud_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
