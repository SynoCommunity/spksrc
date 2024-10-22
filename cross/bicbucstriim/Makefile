PKG_NAME = BicBucStriim
PKG_VERS = 3.5.2
PKG_EXT = zip
PKG_DIST_NAME = bicbucstriim-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mikespub-org/rvolz-$(PKG_NAME)/releases/download/v$(PKG_VERS)
PKG_DIR = bicbucstriim
EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)

DEPENDS =

HOMEPAGE = https://github.com/mikespub-org/rvolz-BicBucStriim/
COMMENT  = BicBucStriim streams books, digital books. It fills a gap in the functionality of current NAS devices, which provide access to your collection of music, videos and photos -- but not books. BicBucStriim covers that area and provides web-based access to your e-book collection.
LICENSE  = MIT

INSTALL_TARGET = bicbucstriim_install

include ../../mk/spksrc.install-resources.mk

.PHONY: bicbucstriim_install
bicbucstriim_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/bbs
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/bbs
