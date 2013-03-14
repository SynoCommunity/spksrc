PKG_NAME = newznab
PKG_VERS = 0.2.3
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.newznab.com
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/pear

HOMEPAGE = http://www.newznab.com/
COMMENT  = Newznab is a usenet indexing application, that makes building a usenet community easy.
LICENSE  = GPLv3

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/newznab
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/newznab
