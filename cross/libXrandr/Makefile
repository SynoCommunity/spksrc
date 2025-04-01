PKG_NAME = libXrandr
PKG_VERS = 1.5.4
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.x.org/archive/individual/lib
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libX11 cross/libXext cross/libXrender cross/xorgproto

HOMEPAGE = https://www.x.org
COMMENT  = X.Org X11 libXrandr runtime library.
LICENSE  = GPLv2/GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --datarootdir=$(INSTALL_PREFIX)/lib
CONFIGURE_ARGS += --enable-malloc0returnsnull
CONFIGURE_ARGS += --disable-static

include ../../mk/spksrc.cross-cc.mk
