PKG_NAME = libXi
PKG_VERS = 1.7.9
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.x.org/archive/individual/lib
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/xorg-x11-util-macros cross/libX11 cross/libXext cross/libXfixes cross/x11proto

HOMEPAGE = https://www.x.org
COMMENT  = X.Org X11 libXi runtime library
LICENSE  = GPLv2/GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --datarootdir=$$INSTALL_PREFIX/lib \
	--enable-malloc0returnsnull \
	--disable-specs \
	--disable-static
PRE_CONFIGURE_TARGET = libXi_pre_configure

ifeq ($(findstring $(ARCH), ppc824x ppc853x),$(ARCH))
ifneq (5,$(firstword $(sort $(TCVERSION) 5)))
# toolchains before version 5 require the old linux quota version
# related issue: https://github.com/transmission/transmission/issues/591
ADDITIONAL_CFLAGS = -D_LINUX_QUOTA_VERSION=1
endif
endif


include ../../mk/spksrc.cross-cc.mk

.PHONY: libXi_pre_configure
libXi_pre_configure:
	$(RUN) autoreconf -i -f -v -I $(INSTALL_DIR)$(INSTALL_PREFIX)/lib/aclocal

