PKG_NAME = ente-web
PKG_VERS = 1.7.14
PKG_EXT = tar.gz
PKG_DIST_NAME = photosd-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ente-io/ente/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = ente-photosd-v$(PKG_VERS)

BUILD_DEPENDS = native/nodejs

HOMEPAGE = https://ente.io
COMMENT  = Ente Photos web frontend - self-hosted photo storage and sharing
LICENSE  = AGPL-3.0

INSTALL_TARGET = ente_web_install

include ../../mk/spksrc.install-resources.mk

ENV += NPM_CONFIG_USER=root
PATH := $(WORK_DIR)/../../../native/nodejs/work-native/node/bin:$(PATH)

.PHONY: ente_web_install
ente_web_install:
	@$(MSG) "Installing yarn globally"
	cd $(WORK_DIR)/$(PKG_DIR)/web && PATH=$(PATH) npm install -g yarn
	@$(MSG) "Building Ente Photos web app"
	cd $(WORK_DIR)/$(PKG_DIR)/web && PATH=$(PATH) yarn install --frozen-lockfile
	cd $(WORK_DIR)/$(PKG_DIR)/web && PATH=$(PATH) yarn build:photos
	@$(MSG) "Installing Ente Photos web app"
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/web
	cp -R $(WORK_DIR)/$(PKG_DIR)/web/apps/photos/out/* $(STAGING_INSTALL_PREFIX)/web/