PKG_NAME = apr-util
PKG_VERS = 1.6.3
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://archive.apache.org/dist/apr
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/apr cross/libexpat

HOMEPAGE = https://apr.apache.org
COMMENT  = APR-util provides a number of helpful abstractions on top of APR.
LICENSE  = Apache 2.0

POST_CONFIGURE_TARGET = apr-util_post_configure
POST_INSTALL_TARGET = apr-util_post_install

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --enable-layout=GNU
CONFIGURE_ARGS += --with-apr=$(STAGING_INSTALL_PREFIX)/bin/apr-1-config
ADDITIONAL_CFLAGS = -I$(STAGING_INSTALL_PREFIX)/include/apache2

include ../../mk/spksrc.cross-cc.mk

.PHONY: apr-util_post_configure
apr-util_post_configure:
	cp $(STAGING_INSTALL_PREFIX)/share/apache2/build/apr_rules.mk $(WORK_DIR)/$(PKG_DIR)/build/rules.mk
	sed -e 's#^apr_builddir=\(.*\)$$#apr_builddir=$(INSTALL_DIR)\1#' \
	    -e 's#^apr_builders=\(.*\)$$#apr_builders=$(INSTALL_DIR)\1#' \
		 -e 's#^top_builddir=\(.*\)$$#top_builddir=$(INSTALL_DIR)\1#' \
		 -i $(WORK_DIR)/$(PKG_DIR)/build/rules.mk

.PHONY: apr-util_post_install
apr-util_post_install:
	sed -i -e 's|^prefix="$(INSTALL_PREFIX)"$$|prefix="$(STAGING_INSTALL_PREFIX)"|' $(STAGING_INSTALL_PREFIX)/bin/apr-1-config
