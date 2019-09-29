PKG_NAME = bazarr
BAZARR_VERSION = 0.8.2.4
PKG_VERS = v$(BAZARR_VERSION)
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_DIST_NAME)
PKG_DIST_SITE = https://github.com/morpheus65535/bazarr/archive
PKG_DIR = $(PKG_NAME)-$(BAZARR_VERSION)

DEPENDS = 

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = bazarrInstall

HOMEPAGE = https://www.bazarr.media
LICENSE = GPLv3

include ../../mk/spksrc.python-wheel.mk

.PHONY: bazarrInstall
bazarrInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
