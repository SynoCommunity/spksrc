PKG_NAME = paperless
PKG_VERS = 2.7.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/the-paperless-project/$(PKG_NAME)/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://paperless.readthedocs.io
LICENSE  = GPLv3

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: paperless_install
paperless_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/paperless
	ls -Rl $(WORK_DIR)/$(PKG_DIR)/
	ls -Rl $(STAGING_INSTALL_PREFIX)

