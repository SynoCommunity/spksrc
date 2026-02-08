PKG_NAME = libX11
PKG_VERS = 1.8.10
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://xorg.freedesktop.org/archive/individual/lib
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/xorgproto cross/libxcb cross/xtrans cross/xorg-sgml-doctools cross/libICE cross/libSM

HOMEPAGE = https://www.x.org
COMMENT  = Development files for libX11.
LICENSE  = GPLv2/GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --enable-malloc0returnsnull
CONFIGURE_ARGS += --disable-silent-rules
CONFIGURE_ARGS += --without-xmlto
CONFIGURE_ARGS += --without-fop
CONFIGURE_ARGS += --disable-static

ADDITIONAL_CFLAGS = -Os

include ../../mk/spksrc.cross-cc.mk
