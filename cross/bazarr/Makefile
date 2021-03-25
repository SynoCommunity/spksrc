PKG_NAME = bazarr

PKG_VERS = 0.9.3
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/morpheus65535/bazarr/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = bazarr_custom_install

DEPENDS = cross/unrar
DEPENDS += cross/numpy
DEPENDS += cross/webrtcvad

HOMEPAGE = https://www.bazarr.media
LICENSE = GPLv3

include ../../mk/spksrc.python-module.mk

.PHONY: bazarr_custom_install
bazarr_custom_install: 
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
