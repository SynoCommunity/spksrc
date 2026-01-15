PKG_NAME = libICE
PKG_VERS = 1.1.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.x.org/archive/individual/lib
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/xorg-x11-util-macros cross/xorgproto cross/xtrans

HOMEPAGE = https://www.x.org
COMMENT  = X.Org X11 ICE runtime library.
LICENSE  = GPLv2/GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --datarootdir=$(INSTALL_PREFIX)/lib
CONFIGURE_ARGS += --without-fop
CONFIGURE_ARGS += --without-xmlto
CONFIGURE_ARGS += --disable-static

include ../../mk/spksrc.cross-cc.mk
