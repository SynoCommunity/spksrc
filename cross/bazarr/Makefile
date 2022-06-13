PKG_NAME = bazarr
PKG_VERS = 1.0.4
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/morpheus65535/bazarr/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)

INSTALL_TARGET = bazarr_custom_install

HOMEPAGE = https://www.bazarr.media
LICENSE = GPLv3

include ../../mk/spksrc.install-resources.mk

.PHONY: bazarr_custom_install
bazarr_custom_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
	tar -cf - -C $(EXTRACT_PATH) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
