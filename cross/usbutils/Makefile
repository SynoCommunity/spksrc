PKG_NAME = usbutils
PKG_VERS = 007
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.iij.ad.jp/pub/linux/kernel/linux/utils/usb/usbutils/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libusb

HOMEPAGE = http://www.linux-usb.org/
COMMENT  = Collection of USB tools for use on Linux and BSD systems to query what type of USB devices are connected to the system.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
