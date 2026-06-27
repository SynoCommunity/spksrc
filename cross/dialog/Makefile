PKG_NAME = dialog
PKG_VERS = 1.3-20260107
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://invisible-island.net/archives/dialog
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw

HOMEPAGE = https://invisible-island.net/dialog/
COMMENT = dialog is a script-interpreter which provides a set of curses widgets. Widgets are objects whose appearance and behavior can be customized.
LICENSE = LGPL 2.1

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --with-ncursesw
CONFIGURE_ARGS += --with-shared

include ../../mk/spksrc.cross-cc.mk
