PKG_NAME = phpMemcachedAdmin
PKG_VERS = 1.2.2-r262
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/phpmemcacheadmin
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://code.google.com/p/phpmemcacheadmin/
COMMENT  = Graphic stand-alone administration for memcached to monitor and debug purpose
LICENSE  = Apache License 2.0

EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/phpMemcachedAdmin
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/phpMemcachedAdmin
