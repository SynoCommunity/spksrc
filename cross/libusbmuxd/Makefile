PKG_NAME = libusbmuxd
PKG_VERS = 2.0.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libimobiledevice/libusbmuxd/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libplist

HOMEPAGE = https://github.com/libimobiledevice/libusbmuxd/
COMMENT  = A client library to multiplex connections from and to iOS devices by connecting to a socket provided by a usbmuxd daemon.
LICENSE  = LGPL-2.1

GNU_CONFIGURE = 1
CONFIGURE_ARGS = ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes

include ../../mk/spksrc.cross-cc.mk
