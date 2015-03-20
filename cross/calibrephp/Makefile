PKG_NAME = calibrephp
PKG_VERS = 0.0.1
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/demorfi/calibrephp/releases/download/$(PKG_VERS)
PKG_DIR =

DEPENDS =

HOMEPAGE = https://github.com/demorfi/calibrephp
COMMENT  = Calibre OPDS and HTML PHP Server.
LICENSE  = GPL

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/calibrephp
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/calibrephp
