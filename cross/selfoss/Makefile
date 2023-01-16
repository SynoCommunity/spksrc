PKG_NAME = selfoss
PKG_VERS = 2.13
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/SSilence/selfoss/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://selfoss.aditu.de/
COMMENT  = The new multipurpose rss reader, live stream, mashup, aggregation web application.
LICENSE  = GPLv3

EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)
INSTALL_TARGET = selfoss_install

include ../../mk/spksrc.install-resources.mk

.PHONY: selfoss_install
selfoss_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/selfoss
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/selfoss
