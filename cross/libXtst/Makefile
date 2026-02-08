PKG_NAME = libXtst
PKG_VERS = 1.2.5
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.x.org/archive/individual/lib
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libX11 cross/libXi

HOMEPAGE = https://www.x.org
COMMENT  = X.Org X11 libXtst runtime library.
LICENSE  = GPLv2/GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --datarootdir=$(INSTALL_PREFIX)/lib
CONFIGURE_ARGS += --without-xmlto
CONFIGURE_ARGS += --without-fop
CONFIGURE_ARGS += --disable-static

include ../../mk/spksrc.cross-cc.mk
