PKG_NAME = libimobiledevice
PKG_VERS = 1.3.0
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libimobiledevice/libimobiledevice/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libplist cross/libusbmuxd cross/openssl3

HOMEPAGE = https://github.com/libimobiledevice/libimobiledevice/
COMMENT  = A library to communicate with services of Apple iOS devices using native protocols.
LICENSE  = LGPL-2.1

PATCHES_LEVEL = 1

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --without-cython
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
