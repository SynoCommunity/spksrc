PKG_NAME = tiff
PKG_VERS = 3.9.5
PKG_EXT = tar.gz
PKG_REV = 1
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://download.osgeo.org/libtiff/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.remotesensing.org/libtiff/
COMMENT  =
LICENSE  =


GNU_CONFIGURE = 1
CONFIGURE_ARGS = --libdir=$(INSTALL_PREFIX)/lib

INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) make install DESTDIR=$(INSTALL_DIR)

