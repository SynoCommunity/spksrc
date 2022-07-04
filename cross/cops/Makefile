PKG_NAME = cops
PKG_VERS = 1.0.1
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/seblucas/cops/releases/download/$(PKG_VERS)
PKG_DIR = 

DEPENDS =

HOMEPAGE = https://blog.slucas.fr/en/oss/calibre-opds-php-server
COMMENT  = Calibre OPDS and HTML PHP Server : light alternative to Calibre content server / Calibre2OPDS.
LICENSE  = GPL

INSTALL_TARGET = cops_install

include ../../mk/spksrc.install-resources.mk

.PHONY: cops_install
cops_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/cops
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/cops
