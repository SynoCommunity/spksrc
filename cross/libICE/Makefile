PKG_NAME = libICE
PKG_VERS = 1.0.10
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.x.org/archive/individual/lib
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/xorg-x11-util-macros cross/x11proto cross/xtrans

HOMEPAGE = https://www.x.org
COMMENT  = X.Org X11 ICE runtime library
LICENSE  = GPLv2/GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --datarootdir=$$INSTALL_PREFIX/lib \
	--without-fop \
	--without-xmlto
PRE_CONFIGURE_TARGET = libICE_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: libICE_pre_configure
libICE_pre_configure:
	$(RUN) autoreconf -i -f -v -I $(INSTALL_DIR)$(INSTALL_PREFIX)/lib/aclocal
