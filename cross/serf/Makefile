PKG_NAME = serf
PKG_VERS = 1.3.10
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://archive.apache.org/dist/serf
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/apr cross/apr-util cross/openssl3

HOMEPAGE = https://serf.apache.org
COMMENT  = The serf library is a high performance C-based HTTP client library built upon the Apache Portable Runtime (APR) library. Serf is the default client library of Apache Subversion and Apache OpenOffice.
LICENSE  = Apache 2.0

CONFIGURE_TARGET = nop
COMPILE_TARGET = serf_compile
INSTALL_TARGET = serf_install

CONFIGURE_ARGS  = --with-apr=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-apr-util=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk

.PHONY: serf_compile
serf_compile:
	cd $(WORK_DIR)/$(PKG_DIR) && scons CC=$(TC_PATH)/$(TC_PREFIX)gcc APR=$(STAGING_INSTALL_PREFIX) APU=$(STAGING_INSTALL_PREFIX) OPENSSL=$(STAGING_INSTALL_PREFIX) PREFIX=$(INSTALL_PREFIX) LIBDIR=$(STAGING_INSTALL_PREFIX)/lib

.PHONY: serf_install
serf_install:
	cd $(WORK_DIR)/$(PKG_DIR) && scons PREFIX=$(STAGING_INSTALL_PREFIX) install
