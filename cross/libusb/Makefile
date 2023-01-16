PKG_NAME = libusb
PKG_VERS = 1.0.23
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
CONFIGURE_ARGS = --disable-udev --disable-debug-log --disable-examples-build
LIBUSB_AUTOGEN_ARGS = $(CONFIGURE_ARGS)

include ../../mk/spksrc.cross-cc.mk


ifeq ($(findstring $(ARCH),$(ARM_ARCHS)),$(ARCH))
LIBUSB_AUTOGEN_ARGS += --host=arm-linux
endif
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
LIBUSB_AUTOGEN_ARGS += --host=ppc-linux
endif

.PHONY: libusb_pre_configure
libusb_pre_configure:
	$(RUN) ; ./autogen.sh $(LIBUSB_AUTOGEN_ARGS)
