PKG_NAME = libhdhomerun
PKG_VERS = 20180817
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://download.silicondust.com/hdhomerun
PKG_DIR = $(PKG_NAME)

DEPENDS =

HOMEPAGE = https://www.silicondust.com/hdhomerun/
COMMENT  = HDHomerun Library
LICENSE  = GNU LGPL2.1, Feb 1999

CONFIGURE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/include/libhdhomerun
	@install -m 644 $(INSTALL_DIR)/../$(PKG_DIR)/*.h $(STAGING_INSTALL_PREFIX)/include/libhdhomerun/
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/lib
	@install -m 644 $(INSTALL_DIR)/../$(PKG_DIR)/libhdhomerun.so $(STAGING_INSTALL_PREFIX)/lib/
