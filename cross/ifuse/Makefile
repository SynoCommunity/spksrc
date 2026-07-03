PKG_NAME = ifuse
PKG_VERS = 1.1.4
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libimobiledevice/ifuse/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libplist cross/libimobiledevice cross/fuse

HOMEPAGE = https://github.com/libimobiledevice/ifuse/
COMMENT  = A fuse filesystem implementation to access the contents of iOS devices.
LICENSE  = LGPL-2.1

GNU_CONFIGURE = 1
# avoid prefix definition for make install
INSTALL_MAKE_OPTIONS = install DESTDIR=$(INSTALL_DIR)

include ../../mk/spksrc.cross-cc.mk
