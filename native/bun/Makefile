PKG_NAME = bun-linux-x64
PKG_VERS = 1.4.2
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/oven-sh/bun/releases/download/bun-v$(PKG_VERS)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)

DEPENDS =

HOMEPAGE = https://bun.com/
COMMENT = Incredibly fast JavaScript runtime, bundler, test runner, and package manager – all in one.
LICENSE = MIT

INSTALL_TARGET = bun_install

include ../../mk/spksrc.native-install.mk

.PHONY bun_install:
bun_install:
	@install -d $(INSTALL_DIR)/usr/local/bin
	@install -m 755 $(WORK_DIR)/$(PKG_NAME)/bun $(INSTALL_DIR)/usr/local/bin/
