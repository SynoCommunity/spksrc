PKG_NAME = libxml2
PKG_VERS = 2.9.10
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://xmlsoft.org/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/libiconv

HOMEPAGE = http://xmlsoft.org
COMMENT  = Libxml2 is the XML C parser and toolkit developed for the Gnome project (but usable outside of the Gnome platform)
LICENSE  = MIT

CONFIGURE_ARGS = --without-lzma  --with-iconv  --without-python --with-pic
GNU_CONFIGURE = 1
ADDITIONAL_CFLAGS = -O3
POST_INSTALL_TARGET = libxml2_post_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: libxml2_post_install
libxml2_post_install:
	sed -i -e 's|^prefix=$(INSTALL_PREFIX)$$|prefix=$(STAGING_INSTALL_PREFIX)|' $(STAGING_INSTALL_PREFIX)/bin/xml2-config
	cp $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/pkgconfig/libxml-2.0.pc $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/pkgconfig/libxml2.pc
