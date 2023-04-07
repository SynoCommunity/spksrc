PKG_NAME = nodejs
# https://nodejs.org/en/about/releases/
# v18 is active LTS Version "Hydrogen" from 2022-10-25 to 2023-10-18 with EOL at 2025-04-30
PKG_VERS = 18.15.0
PKG_EXT = tar.xz
PKG_DIST_NAME = node-v$(PKG_VERS)-linux-x64.$(PKG_EXT)
PKG_DIST_SITE = https://nodejs.org/dist/v$(PKG_VERS)
PKG_DIR = node-v$(PKG_VERS)-linux-x64

HOMEPAGE = https://nodejs.org/
COMMENT  = JavaScript runtime built on Chrome's V8 JavaScript engine.
LICENSE  = https://github.com/nodejs/node/blob/master/LICENSE

INSTALL_TARGET = nodejs-install

include ../../mk/spksrc.native-install.mk

.PHONY: nodejs-install
nodejs-install:
	@mv -f $(WORK_DIR)/$(PKG_DIR)/ $(WORK_DIR)/node/
