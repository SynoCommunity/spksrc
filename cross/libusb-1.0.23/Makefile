PKG_NAME = libusb
# 1.0.23 is the last release that builds as C99: 1.0.24 made C11 a requirement, which
# the archs below have no default dialect for. Kept frozen for them.
PKG_VERS = 1.0.23
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libusb/libusb/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://libusb.info/
COMMENT  = C library that provides generic access to USB devices. It is intended to be used by developers to facilitate the production of applications that communicate with USB hardware.
LICENSE  = LGPL-2.1

GNU_CONFIGURE = 1

CONFIGURE_ARGS += --disable-static
CONFIGURE_ARGS += --disable-udev

ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
