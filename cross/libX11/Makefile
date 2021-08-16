PKG_NAME = libX11
PKG_VERS = 1.7.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://xorg.freedesktop.org/archive/individual/lib
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/x11proto cross/xcb-proto cross/xcb cross/xtrans cross/xorg-sgml-doctools cross/libICE cross/libSM

HOMEPAGE = https://www.x.org
COMMENT  = Development files for libX11
LICENSE  = GPLv2/GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-malloc0returnsnull \
	--disable-silent-rules \
	--without-xmlto \
	--without-fop \
	--disable-static
PRE_CONFIGURE_TARGET = libX11_pre_configure
PATCHES_LEVEL = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: libX11_pre_configure
libX11_pre_configure:
	$(RUN) autoreconf -i -f -v -I $(INSTALL_DIR)$(INSTALL_PREFIX)/lib/aclocal

