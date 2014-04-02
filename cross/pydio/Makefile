PKG_NAME = pydio
PKG_FILENAME = $(PKG_NAME)-core
PKG_VERS = 5.2.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_FILENAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/ajaxplorer/files/pydio/stable-channel/$(PKG_VERS)
PKG_DIR = $(PKG_FILENAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://pyd.io/
COMMENT  = Pydio allows you to instantly turn any server into a powerful file sharing platform.
LICENSE  =  AGPLv3

EXTRACT_PATH = $(WORK_DIR)
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/pydio
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/pydio
