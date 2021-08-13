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
	--disable-static
PRE_CONFIGURE_TARGET = libX11_pre_configure

ifeq ($(findstring $(ARCH), ppc824x ppc853x),$(ARCH))
ifneq (5,$(firstword $(sort $(TCVERSION) 5)))
# toolchains before version 5 require the old linux quota version
# related issue: https://github.com/transmission/transmission/issues/591
ADDITIONAL_CFLAGS = -D_LINUX_QUOTA_VERSION=1
endif
endif
PATCHES_LEVEL = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: libX11_pre_configure
libX11_pre_configure:
	$(RUN) autoreconf -i -f -v -I $(INSTALL_DIR)$(INSTALL_PREFIX)/lib/aclocal

