PKG_NAME = nzbgetweb
PKG_VERS = 1.5
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/nzbget/web-interface-stable/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)

DEPENDS =

HOMEPAGE = http://nzbget.sourceforge.net/
COMMENT  = Web-interface for NZBGet.
LICENSE  = 

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/nzbgetweb
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/nzbgetweb

