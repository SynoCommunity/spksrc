PKG_NAME = usbutils
PKG_VERS = 007
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.iij.ad.jp/pub/linux/kernel/linux/utils/usb/usbutils
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

OPTIONAL_DEPENDS = cross/libusb cross/libusb_1.0.23

HOMEPAGE = http://www.linux-usb.org/
COMMENT  = Collection of USB tools for use on Linux and BSD systems to query what type of USB devices are connected to the system.
LICENSE  = GPLv2

include ../../mk/spksrc.common.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(PPC_ARCHS)),$(ARCH))
DEPENDS += cross/libusb_1.0.23
else ifeq ($(call version_lt, ${TCVERSION}, 6.0)$(call version_ge, ${TCVERSION}, 3.0),11)
DEPENDS += cross/libusb_1.0.23
else
DEPENDS += cross/libusb
endif

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
