PKG_NAME = libxslt
PKG_VERS = 1.1.29
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://xmlsoft.org/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libxml2 cross/libgcrypt

HOMEPAGE = http://xmlsoft.org/
COMMENT  = Libxslt is the XSLT C library developed for the GNOME project
LICENSE  = MIT

CONFIGURE_ARGS  = --without-python --with-libxml-prefix=$(STAGING_INSTALL_PREFIX)
GNU_CONFIGURE = 1

# if for libgcrypt, replace the -config path with abspath
POST_INSTALL_TARGET = libxslt_post_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: libxslt_post_install
libxslt_post_install:
	sed -i -e 's|^prefix=$(INSTALL_PREFIX)$$|prefix=$(STAGING_INSTALL_PREFIX)|' $(STAGING_INSTALL_PREFIX)/bin/xslt-config
