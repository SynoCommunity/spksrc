PKG_NAME = libXau
PKG_VERS = 1.0.12
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.x.org/archive/individual/lib
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/xorg-x11-util-macros cross/xorgproto

HOMEPAGE = https://www.x.org
COMMENT  = Sample Authorization Protocol for X.
LICENSE  = GPLv2/GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --datarootdir=$(INSTALL_PREFIX)/lib
CONFIGURE_ARGS += --disable-static

ADDITIONAL_CFLAGS = -Os

include ../../mk/spksrc.cross-cc.mk
