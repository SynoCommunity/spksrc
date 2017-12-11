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
CONFIGURE_ARGS += --with-libxml-include-prefix=$(STAGING_INSTALL_PREFIX)/include/libxml2
GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
