PKG_NAME = libftdi1
PKG_VERS = 1.0
PKG_EXT = tar.bz2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.intra2net.com/en/developer/libftdi/download/

DEPENDS = cross/libusb cross/libconfuse

HOMEPAGE = http://www.intra2net.com/en/developer/libftdi/
COMMENT = LIBFTDI
LICENSE =

CONFIGURE_TARGET = myConfigure
INSTALL_TARGET = myInstall

ENV += CMAKE_INCLUDE_PATH="$(STAGING_INSTALL_PREFIX)/include" CMAKE_LIBRARY_PATH="$(STAGING_INSTALL_PREFIX)/lib"

include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure:
	$(RUN) cmake -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX) CMakeLists.txt

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
