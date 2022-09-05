PKG_NAME = libxml2
PKG_VERS = 2.9.12
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://xmlsoft.org/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

HOMEPAGE = http://xmlsoft.org
COMMENT  = Libxml2 is the XML C parser and toolkit developed for the Gnome project (but usable outside of the Gnome platform)
LICENSE  = MIT

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --without-python
ADDITIONAL_CFLAGS = -O3

POST_INSTALL_TARGET = libxml2_post_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: libxml2_post_install
libxml2_post_install:
	sed -i -e 's|^prefix=$(INSTALL_PREFIX)$$|prefix=$(STAGING_INSTALL_PREFIX)|' $(STAGING_INSTALL_PREFIX)/bin/xml2-config
