PKG_NAME = libX11
PKG_VERS = 1.7.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://xorg.freedesktop.org/archive/individual/lib
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/xorgproto cross/xcb-proto cross/libxcb cross/xtrans cross/xorg-sgml-doctools cross/libICE cross/libSM

HOMEPAGE = https://www.x.org
COMMENT  = Development files for libX11
LICENSE  = GPLv2/GPLv3

PRE_CONFIGURE_TARGET = $(PKG_NAME)_pre_configure
GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --enable-malloc0returnsnull
CONFIGURE_ARGS += --disable-silent-rules
CONFIGURE_ARGS += --without-xmlto
CONFIGURE_ARGS += --without-fop
CONFIGURE_ARGS += --disable-static
PATCHES_LEVEL = 1

ADDITIONAL_CFLAGS = -Os

include ../../mk/spksrc.cross-cc.mk

.PHONY: $(PKG_NAME)_pre_configure
$(PKG_NAME)_pre_configure:
	$(RUN) autoreconf -i -f -v -I $(INSTALL_DIR)$(INSTALL_PREFIX)/lib/aclocal

