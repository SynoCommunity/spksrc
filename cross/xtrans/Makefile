PKG_NAME = xtrans
PKG_VERS = 1.5.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.x.org/archive/individual/lib
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/xorg-x11-util-macros

HOMEPAGE = https://www.x.org
COMMENT  = X.Org X11 developmental X transport library.
LICENSE  = GPLv2/GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --datarootdir=$(INSTALL_PREFIX)/lib
CONFIGURE_ARGS += --disable-docs
PATCHES_LEVEL = 1

include ../../mk/spksrc.cross-cc.mk
