PKG_NAME = pnpm
PKG_VERS = 10.4.1
PKG_DIST_NAME = pnpm-linux-x64
PKG_DIST_SITE = https://github.com/pnpm/pnpm/releases/download/v$(PKG_VERS)

HOMEPAGE = https://pnpm.io/
COMMENT  = Fast, disk space efficient package manager.
LICENSE  = MIT

EXTRACT_TARGET = pnpm-extract
INSTALL_TARGET = nop

include ../../mk/spksrc.native-install.mk

.PHONY: pnpm-extract
pnpm-extract:
	@$(MSG) Nothing to extract, install binary $(PKG_DIST_NAME) as pnpm
	@install -m 755 -d $(WORK_DIR)/bin
	@install -m 755 $(DIST_FILE) $(WORK_DIR)/bin/pnpm
