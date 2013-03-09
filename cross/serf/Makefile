PKG_NAME = serf
PKG_VERS = 1.2.0
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://serf.googlecode.com/files
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/apr cross/apr-util cross/openssl

HOMEPAGE = https://code.google.com/p/serf/
COMMENT  = The serf library is a high performance C-based HTTP client library built upon the Apache Portable Runtime (APR) library
LICENSE  = Apache v2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-apr=$(STAGING_INSTALL_PREFIX) --with-apr-util=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPostInstall
myPostInstall:
	sed -i -e 's|^prefix="$(INSTALL_PREFIX)"$$|prefix="$(STAGING_INSTALL_PREFIX)"|' $(STAGING_INSTALL_PREFIX)/bin/serf-config
