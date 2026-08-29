PKG_NAME      = Komga
PKG_VERS      = 1.24.4
PKG_EXT       = jar
PKG_DIST_NAME = komga-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = komga-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/gotson/komga/releases/download/$(PKG_VERS)
PKG_DIR       = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://komga.org/
COMMENT  = Komga is a media server for your comics, mangas, BDs, magazines and eBooks.
LICENSE  = MIT

INSTALL_TARGET = komga_install

include ../../mk/spksrc.install-resources.mk

.PHONY: komga_install
komga_install:
	@mkdir -p $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(DISTRIB_DIR)/$(PKG_DIST_FILE) $(STAGING_INSTALL_PREFIX)/bin/komga.jar
