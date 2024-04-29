PKG_NAME = libxslt
PKG_VERS = 1.1.39
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.gnome.org/sources/libxslt/$(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libxml2 cross/libgcrypt

HOMEPAGE = https://gitlab.gnome.org/GNOME/libxslt/-/wikis/home
COMMENT  = Libxslt is the XSLT C library developed for the GNOME project.
LICENSE  = MIT

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --without-python

# if for libgcrypt, replace the -config path with abspath
POST_INSTALL_TARGET = libxslt_post_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: libxslt_post_install
libxslt_post_install:
	sed -i -e 's|^prefix=$(INSTALL_PREFIX)$$|prefix=$(STAGING_INSTALL_PREFIX)|' $(STAGING_INSTALL_PREFIX)/bin/xslt-config
