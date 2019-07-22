PKG_NAME = libusb
PKG_VERS = 1.0.9
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libusb/libusb/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://libusb.info/
COMMENT  = C library that provides generic access to USB devices. It is intended to be used by developers to facilitate the production of applications that communicate with USB hardware.
LICENSE  = LGPL-2.1

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = libusb_pre_configure

include ../../mk/spksrc.cross-cc.mk

LIBUSB_AUTOGEN_PARAMS =

ifeq ($(findstring $(ARCH), $(ARM_ARCHES)),$(ARCH))
LIBUSB_AUTOGEN_PARAMS += --host=arm-linux
endif

libusb_pre_configure:
	$(RUN) ; ./autogen.sh $(LIBUSB_AUTOGEN_PARAMS)
