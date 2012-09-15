PKG_NAME = pyload
PKG_VERS = 0.4.9
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)-src-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://get.pyload.org/get/src
PKG_DIR = $(PKG_NAME)

DEPENDS = 

HOMEPAGE   = http://pyload.org/
COMMENT    = Fast, lightweight and full featured download manager for many One-Click-Hoster
LICENSE    = GPL

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/pyLoad
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/pyLoad
