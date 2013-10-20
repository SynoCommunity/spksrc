PKG_NAME = libusb-compat
PKG_VERS = 0.1.5
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/libusb/files/libusb-compat-0.1/libusb-compat-0.1.5/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libusb

HOMEPAGE = http://sourceforge.net/projects/libusb/
COMMENT  = Library to enable user space application programs to communicate with USB devices
LICENSE  =

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
