PKG_NAME = jellyfin-web
PKG_VERS = 10.8.4
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/jellyfin/jellyfin-web/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/nodejs

HOMEPAGE = https://jellyfin.org
COMMENT  = Jellyfin Web is the frontend used for most of the clients available for end users.
LICENSE  = GPLv2

INSTALL_TARGET = jellyfin_install

include ../../mk/spksrc.install-resources.mk

ENV += NPM_CONFIG_USER=root
PATH := $(WORK_DIR)/../../../native/nodejs/work-native/node/bin:$(PATH)

.PHONY: jellyfin_install
jellyfin_install:
	$(RUN) npm install && npm run build:production
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/web
	cp -R $(WORK_DIR)/$(PKG_DIR)/dist/* $(STAGING_INSTALL_PREFIX)/web/
