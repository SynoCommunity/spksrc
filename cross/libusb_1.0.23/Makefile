PKG_NAME = libusb
PKG_VERS = 1.0.23
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libusb/libusb/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# this is the latest version that builds with C99 compiler.
# libusb >= v1.0.24 needs C11 compiler (not supported by OLD_PPC_ARCHS, ARMv5_ARCHS and ARMv7L_ARCHS).
# qoriq has C11 compiler, but fails with "configure: error: Linux netlink header not found"

DEPENDS =

HOMEPAGE = https://libusb.info/
COMMENT  = C library that provides generic access to USB devices. It is intended to be used by developers to facilitate the production of applications that communicate with USB hardware.
LICENSE  = LGPL-2.1

GNU_CONFIGURE = 1
ifneq ($(strip $(LIBUSB_ENABLE_STATIC)),1)
CONFIGURE_ARGS += --disable-static
endif
ifneq ($(strip $(LIBUSB_WITH_LIBUDEV)),1)
CONFIGURE_ARGS += --disable-udev
endif
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
