PKG_NAME = libXfixes
PKG_VERS = 6.0.0
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.x.org/archive/individual/lib
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/xorg-x11-util-macros cross/libX11

HOMEPAGE = https://www.x.org
COMMENT  = X Fixes library
LICENSE  = GPLv2/GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --datarootdir=$$INSTALL_PREFIX/lib \
	--without-xmlto \
	--without-fop \
	--disable-static

PRE_CONFIGURE_TARGET = libXfixes_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: libXfixes_pre_configure
libXfixes_pre_configure:
	$(RUN) autoreconf -i -f -v -I $(INSTALL_DIR)$(INSTALL_PREFIX)/lib/aclocal

