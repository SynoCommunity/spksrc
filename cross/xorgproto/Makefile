PKG_NAME = xorgproto
PKG_VERS = 2024.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.x.org/archive/individual/proto
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/xorg-x11-util-macros cross/xorg-sgml-doctools

HOMEPAGE = https://www.x.org
COMMENT  = X.Org X11 Protocol headers.
LICENSE  = GPLv2/GPLv3

GNU_CONFIGURE = 1
PKG_CONFIG_PATH = install/usr/local/xorgproto/share/pkgconfig

CONFIGURE_ARGS  = --datarootdir=$(INSTALL_PREFIX)/lib
CONFIGURE_ARGS += --without-xmlto
CONFIGURE_ARGS += --disable-specs

include ../../mk/spksrc.cross-cc.mk
