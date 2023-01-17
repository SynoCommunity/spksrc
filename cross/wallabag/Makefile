PKG_NAME = wallabag
PKG_VERS = 2.2.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-release-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://static.wallabag.org/releases
PKG_DIR = release-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.wallabag.org/
COMMENT  = Wallabag is a self hostable application allowing you to save an offline copy of your favorite articles. Click, save, read it when you can. It extracts content so that you can read it when you have time.
LICENSE  = MIT

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/wallabag
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/wallabag
