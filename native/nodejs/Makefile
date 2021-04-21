PKG_NAME = nodejs
# Latest Current Version: 13.13.0 (includes npm 6.14.4)
PKG_VERS = 13.13.0
PKG_EXT = tar.xz
PKG_DIST_NAME = node-v$(PKG_VERS)-linux-x64.$(PKG_EXT)
PKG_DIST_SITE = https://nodejs.org/dist/v$(PKG_VERS)
PKG_DIR = node-v$(PKG_VERS)-linux-x64

DEPENDS =

HOMEPAGE = https://nodejs.org/
COMMENT  = JavaScript runtime built on Chrome's V8 JavaScript engine.
LICENSE  = https://github.com/nodejs/node/blob/master/LICENSE

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = nodejs-install

include ../../mk/spksrc.native-cc.mk

.PHONY: nodejs-install
nodejs-install:
	mv -f $(WORK_DIR)/$(PKG_DIR)/ $(WORK_DIR)/node/
