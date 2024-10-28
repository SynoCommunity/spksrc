PKG_NAME = jellyseerr
PKG_VERS = 2.0.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Fallenbagel/jellyseerr/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/nodejs

HOMEPAGE = https://docs.jellyseerr.dev/
COMMENT  = Jellyseerr is a free and open source software application for managing requests for your media library.
LICENSE  = MIT

INSTALL_TARGET = jellyseerr_install

include ../../mk/spksrc.install-resources.mk

ENV += NPM_CONFIG_USER=root
PATH := $(WORK_DIR)/../../../native/nodejs/work-native/node/bin:$(PATH)

.PHONY: jellyseerr_install
jellyseerr_install:
	$(RUN) npm install -g pnpm
	install -m 755 -d $(WORK_DIR)/$(PKG_DIR)/.git
	$(RUN) CYPRESS_INSTALL_BINARY=0 pnpm install --frozen-lockfile
	$(RUN) pnpm build
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/web
	cp -R $(WORK_DIR)/$(PKG_DIR)/dist/* $(STAGING_INSTALL_PREFIX)/web/
