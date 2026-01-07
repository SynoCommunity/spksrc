PKG_NAME = usbmuxd
PKG_VERS = 1.1.1
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libimobiledevice/usbmuxd/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libplist cross/libimobiledevice
OPTIONAL_DEPENDS = cross/libusb cross/libusb_1.0.23

HOMEPAGE = https://github.com/libimobiledevice/usbmuxd/
COMMENT  = A socket daemon to multiplex connections from and to iOS devices.
LICENSE  = LGPL-2.1

include ../../mk/spksrc.common.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(PPC_ARCHS)),$(ARCH))
DEPENDS += cross/libusb_1.0.23
else ifeq ($(call version_lt, ${TCVERSION}, 6.0)$(call version_ge, ${TCVERSION}, 3.0),11)
DEPENDS += cross/libusb_1.0.23
else
DEPENDS += cross/libusb
endif

GNU_CONFIGURE = 1
CONFIGURE_ARGS = ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
