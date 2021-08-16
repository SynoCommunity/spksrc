PKG_NAME = libXext
PKG_VERS = 1.3.4
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.x.org/archive/individual/lib
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/xorg-x11-util-macros cross/libX11 cross/x11proto cross/xau

HOMEPAGE = https://www.x.org
COMMENT  = X.Org X11 libXext runtime library
LICENSE  = GPLv2/GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --datarootdir=$$INSTALL_PREFIX/lib \
	--enable-malloc0returnsnull \
	--without-xmlto \
	--without-fop \
	--disable-static

PRE_CONFIGURE_TARGET = libXext_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: libXext_pre_configure
libXext_pre_configure:
	$(RUN) autoreconf -i -f -v -I $(INSTALL_DIR)$(INSTALL_PREFIX)/lib/aclocal

