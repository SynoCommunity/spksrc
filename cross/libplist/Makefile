PKG_NAME = libplist
PKG_VERS = 2.2.0
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libimobiledevice/libplist/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/libimobiledevice/libplist
COMMENT  = A small portable C library to handle Apple Property List files in binary or XML.
LICENSE  = LGPL-2.1

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --without-cython

include ../../mk/spksrc.cross-cc.mk
