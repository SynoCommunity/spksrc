PKG_NAME = pcsc-lite
PKG_VERS = 1.8.8
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://alioth.debian.org/frs/download.php/file/3862
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libusb

HOMEPAGE = http://pcsclite.alioth.debian.org
COMMENT  = Middleware to access a smart card using SCard API (PC/SC).
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --disable-libudev --enable-libusb --enable-usbdropdir=$(INSTALL_PREFIX)/lib/pcsc/drivers

INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) make install DESTDIR=$(INSTALL_DIR)

