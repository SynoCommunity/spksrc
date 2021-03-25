PKG_NAME = phpMemcachedAdmin
PKG_VERS = 1.3.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/elijaa/phpmemcachedadmin/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/elijaa/phpmemcachedadmin
COMMENT  = Graphic stand-alone administration for memcached to monitor and debug purpose
LICENSE  = Apache License 2.0

EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = phpmemcachedadmin_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: phpmemcachedadmin_install
phpmemcachedadmin_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR)/phpmemcachedadmin-$(PKG_VERS) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
