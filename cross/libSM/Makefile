PKG_NAME = libSM
PKG_VERS = 1.2.3
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.x.org/archive/individual/lib
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/xorg-x11-util-macros cross/x11proto cross/xtrans cross/libICE cross/libuuid

HOMEPAGE = https://www.x.org
COMMENT  = X.Org X11 SM runtime library
LICENSE  = GPLv2/GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --datarootdir=$$INSTALL_PREFIX/lib \
	--with-libuuid \
	--disable-static \
	--without-xmlto \
	--without-fop

PRE_CONFIGURE_TARGET = libICE_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: libSM_pre_configure
libSM_pre_configure:
	$(RUN) autoreconf -i -f -v -I $(INSTALL_DIR)$(INSTALL_PREFIX)/lib/aclocal

