PKG_NAME = node-red
PKG_VERS = 3.0.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/node-red/node-red/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/nodejs

HOMEPAGE = https://nodered.org/
COMMENT  = Node-RED is a programming tool for wiring together hardware devices, APIs and online services in new and interesting ways.  It provides a browser-based editor that makes it easy to wire together flows using the wide range of nodes in the palette that can be deployed to its runtime in a single-click.
LICENSE  = Apache 2.0

INSTALL_TARGET = node-red_install

include ../../mk/spksrc.install-resources.mk

PATH := $(WORK_DIR)/../../../native/nodejs/work-native/node/bin:$(PATH)

.PHONY: node-red_install
node-red_install:
	$(RUN) npm install && npm run build
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/packages
	@cp -vR $(WORK_DIR)/$(PKG_DIR)/packages/* $(STAGING_INSTALL_PREFIX)/packages/
