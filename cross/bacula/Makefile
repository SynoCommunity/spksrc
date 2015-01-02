PKG_NAME = bacula
PKG_VERS = 7.0.5
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/bacula/bacula/$(PKG_VERS)

DEPENDS = cross/openssl

HOMEPAGE = http://bacula.org/
COMMENT  = Bacula is an open source backup system
LICENSE  = AGPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-client-only --with-working-dir=$(INSTALL_PREFIX)/var/bacula ac_cv_func_setpgrp_void=yes

INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/var/bacula
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX)
