PKG_NAME = phpMemcachedAdmin
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = aaf3d16a2a1e3dff72dd358f1758d96f0f174cb3
PKG_DIST_SITE = https://github.com/elijaa/phpmemcachedadmin.git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

# Unfortunately only version 1.3.0 is officially released, but
# we need the commit aaf3d16 of 12 Jun 2020 for memcached 1.6.x
# Issue #19: fix mem_requested key change in Memcached 1.5.17

DEPENDS =

HOMEPAGE = https://github.com/elijaa/phpmemcachedadmin
COMMENT  = Graphic stand-alone administration for memcached to monitor and debug purpose.
LICENSE  = Apache 2.0

EXTRACT_PATH = $(WORK_DIR)
INSTALL_TARGET = phpmemcachedadmin_install

include ../../mk/spksrc.install-resources.mk

.PHONY: phpmemcachedadmin_install
# make a copy of the sample config as on DSM7 it is not possible to create this at installation time.
phpmemcachedadmin_install:
	@mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
	@tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
	@cp -f $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)/Config/Memcache.sample.php $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)/Config/Memcache.php
