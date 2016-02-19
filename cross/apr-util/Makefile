PKG_NAME = apr-util
PKG_VERS = 1.5.4
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://apache.crihan.fr/dist/apr
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/apr

HOMEPAGE = http://apr.apache.org/
COMMENT  = APR-util provides a number of helpful abstractions on top of APR.
LICENSE  = 

POST_CONFIGURE_TARGET = myPostConfigure
INSTALL_TARGET = myInstall
POST_INSTALL_TARGET = myPostInstall

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-expat=builtin --enable-layout=GNU --with-apr=$(STAGING_INSTALL_PREFIX)/bin/apr-1-config
ADDITIONAL_CFLAGS = -I$(STAGING_INSTALL_PREFIX)/include/apache2

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPostConfigure
myPostConfigure:
	cp $(STAGING_INSTALL_PREFIX)/share/apache2/build-1/apr_rules.mk $(WORK_DIR)/$(PKG_DIR)/build/rules.mk
	sed -i -e 's#^apr_builddir=\(.*\)$$#apr_builddir=$(INSTALL_DIR)\1#' -e 's#^apr_builders=\(.*\)$$#apr_builders=$(INSTALL_DIR)\1#' -e 's#^top_builddir=\(.*\)$$#top_builddir=$(INSTALL_DIR)\1#' $(WORK_DIR)/$(PKG_DIR)/build/rules.mk

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)

.PHONY: myPostInstall
myPostInstall:
	sed -i -e 's|^prefix="$(INSTALL_PREFIX)"$$|prefix="$(STAGING_INSTALL_PREFIX)"|' $(STAGING_INSTALL_PREFIX)/bin/apr-1-config
