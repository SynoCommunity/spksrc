PKG_NAME = libusb
PKG_VERS = 1.0.19
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/libusb/files/libusb-1.0/libusb-1.0.19
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://sourceforge.net/projects/libusb/
COMMENT  = Library to enable user space application programs to communicate with USB devices
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-udev
#POST_INSTALL_TARGET = myPostInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPostInstall
myPostInstall:
	rm -f $(STAGING_INSTALL_PREFIX)/lib/*.so*
	rm -f $(STAGING_INSTALL_PREFIX)/lib/*.la*
