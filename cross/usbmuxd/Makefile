PKG_NAME = usbmuxd
PKG_VERS = 1.1.1
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libimobiledevice/usbmuxd/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libplist cross/libimobiledevice cross/libusb

HOMEPAGE = https://github.com/libimobiledevice/usbmuxd/
COMMENT  = A socket daemon to multiplex connections from and to iOS devices.
LICENSE  = LGPL-2.1

GNU_CONFIGURE = 1
CONFIGURE_ARGS = ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes

include ../../mk/spksrc.cross-cc.mk
