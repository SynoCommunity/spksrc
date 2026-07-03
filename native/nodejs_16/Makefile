PKG_NAME = nodejs
# https://github.com/nodejs/release#release-schedule
# v16 is EOL Version "Gallium" since 2023-09-11
# v18 is Maintenance Version "Hydrogen" since 2023-10-18 with EOL at 2025-04-30
# v20 is LTS Version "Iron" from 2023-10-24 to 2024-10-22 with EOL at 2026-04-30
PKG_VERS = 16.20.2
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
