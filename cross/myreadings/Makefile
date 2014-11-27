PKG_NAME = myreadings
PKG_VERS = 0.4.3
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/sbdomo/MyReadings/releases/download/0.43
PKG_DIR = $(PKG_NAME)

DEPENDS = 

HOMEPAGE = http://sbdomo.esy.es/my-readings-presentation/
COMMENT  = A web interface for Calibre software
LICENSE  = GPL

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
CONFIGURE_ARGS = 

INSTALL_TARGET = myreadings

include ../../mk/spksrc.cross-cc.mk

.PHONY: myreadings
myreadings:
	 mkdir -p $(STAGING_INSTALL_PREFIX)/share/myreadings
	 tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/myreadings
