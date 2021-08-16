PKG_NAME = libxcb
PKG_VERS = 1.14
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.x.org/archive/individual/lib
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/xorg-x11-util-macros cross/xcb-proto cross/xau

HOMEPAGE = https://www.x.org
COMMENT  = A C binding to the X11 protocol
LICENSE  = GPLv2/GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --datarootdir=$$INSTALL_PREFIX/lib \
	--disable-static \
	--enable-xinput \
	--enable-xkb \
	--enable-sendfds \
	--without-doxygen

PRE_CONFIGURE_TARGET = $(PKG_NAME)_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: $(PKG_NAME)_pre_configure
$(PKG_NAME)_pre_configure:
	$(RUN) autoreconf -i -f -v -I $(INSTALL_DIR)$(INSTALL_PREFIX)/lib/aclocal
