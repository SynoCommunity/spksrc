PKG_NAME = jellyfin-web
PKG_VERS = 10.7.6
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/jellyfin/jellyfin-web/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://jellyfin.org
COMMENT  = Jellyfin Web is the frontend used for most of the clients available for end users
LICENSE  = GPLv2

.PHONY: jellyfin_compile_target
BUILD_DEPENDS = native/nodejs

CONFIGURE_TARGET = nop
COMPILE_TARGET = jellyfin_compile_target
INSTALL_TARGET = nop

include ../../mk/spksrc.cross-dotnet.mk

ENV += NPM_CONFIG_USER=root
PATH := $(WORK_DIR)/../../../native/nodejs/work-native/node/bin:$(PATH)

jellyfin_compile_target:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/web
	$(RUN) npm install && npm run build:production
	cp -R $(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS)/dist/* $(STAGING_INSTALL_PREFIX)/web
