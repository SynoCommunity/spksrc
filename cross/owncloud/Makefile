PKG_NAME = owncloud
PKG_VERS = 8.1.12
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.owncloud.org/community
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://owncloud.org/
COMMENT  = ownCloud gives you universal access to your files through a web interface or WebDAV. It also provides a platform to easily view & sync your contacts, calendars and bookmarks across all your devices and enables basic editing right on the web. Installation has minimal server requirements, doesn’t need special permissions and is quick. ownCloud is extendable via a simple but powerful API for applications and plugins.
LICENSE  = AGPL

EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)
INSTALL_TARGET = owncloud_install

include ../../mk/spksrc.install-resources.mk

.PHONY: owncloud_install
owncloud_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/owncloud
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/owncloud
