PKG_NAME = usbutils
PKG_VERS = 019
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.iij.ad.jp/pub/linux/kernel/linux/utils/usb/usbutils
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

OPTIONAL_DEPENDS  = cross/libusb cross/libusb_1.0.23
OPTIONAL_DEPENDS += cross/libudev_204 cross/libudev_219

HOMEPAGE = http://www.linux-usb.org/
COMMENT  = Collection of USB tools for use on Linux and BSD systems to query what type of USB devices are connected to the system.
LICENSE  = GPLv2

include ../../mk/spksrc.cross-meson.mk

ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
DEPENDS += cross/libusb_1.0.23 cross/libudev_204
else
DEPENDS += cross/libusb cross/libudev_219
endif
