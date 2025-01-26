PKG_NAME = libxcb
PKG_VERS = 1.17.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.x.org/archive/individual/lib
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/xorg-x11-util-macros cross/xcb-proto cross/libXau

HOMEPAGE = https://www.x.org
COMMENT  = A C binding to the X11 protocol.
LICENSE  = GPLv2/GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --datarootdir=$(INSTALL_PREFIX)/lib
CONFIGURE_ARGS += --disable-static
CONFIGURE_ARGS += --enable-xinput
CONFIGURE_ARGS += --enable-xkb
CONFIGURE_ARGS += --without-doxygen

include ../../mk/spksrc.cross-cc.mk
