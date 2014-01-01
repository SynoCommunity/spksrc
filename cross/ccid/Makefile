PKG_NAME = ccid
PKG_VERS = 1.4.11
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://alioth.debian.org/frs/download.php/file/3920
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libusb cross/pcscd-lite

HOMEPAGE = http://pcsclite.alioth.debian.org/ccid.html
COMMENT  = This package provides the source code for a generic USB CCID (Chip/Smart Card Interface Devices) driver and ICCD (Integrated Circuit(s) Card Devices).
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --enable-usbdropdir=$(INSTALL_PREFIX)/lib/pcsc/drivers

INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) make install DESTDIR=$(INSTALL_DIR)

