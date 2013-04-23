PKG_NAME = node
PKG_VERS = 0.10.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://nodejs.org/dist/v$(PKG_VERS)/
PKG_DIR = $(PKG_NAME)-v$(PKG_VERS)

HOMEPAGE = http://nodejs.org/
COMMENT  = Node.js is a platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications.
LICENSE  = MIT

CONFIGURE_ARGS = --without-snapshot --dest-os=linux --prefix=$(STAGING_INSTALL_PREFIX)
ENV += LINK.target=$(TC_PATH)$(TC_PREFIX)g++

POST_INSTALL_TARGET = myPostInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPostInstall
myPostInstall:
	sed -i -e 's|^#\!$(STAGING_INSTALL_PREFIX)|#\!$(INSTALL_PREFIX)|' $(STAGING_INSTALL_PREFIX)/lib/node_modules/npm/bin/npm-cli.js

