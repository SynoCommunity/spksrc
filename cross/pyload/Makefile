PKG_NAME = pyload
PKG_VERS = 0.4.20
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/pyload/pyload/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/tesseract-ocr cross/tessdata-eng cross/js

HOMEPAGE = https://pyload.net/
COMMENT  = pyLoad is a fast, lightweight and full featured download manager for many One-Click-Hoster, container formats like DLC, video sites or just plain http/ftp links.
LICENSE  = GPLv3

INSTALL_TARGET = pyload_install

include ../../mk/spksrc.install-resources.mk

.PHONY: pyload_install
pyload_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
