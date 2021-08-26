PKG_NAME = libXt
PKG_VERS = 1.2.0
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.x.org/archive/individual/lib
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/xorg-x11-util-macros cross/libX11 cross/libSM

HOMEPAGE = https://www.x.org
COMMENT  = X.Org X11 libXt runtime library
LICENSE  = GPLv2/GPLv3

PRE_CONFIGURE_TARGET = $(PKG_NAME)_pre_configure
POST_CONFIGURE_TARGET = $(PKG_NAME)_post_configure_target
GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --datarootdir=$$INSTALL_PREFIX/lib
CONFIGURE_ARGS += --enable-malloc0returnsnull
CONFIGURE_ARGS += --without-xmlto
CONFIGURE_ARGS += --without-fop
CONFIGURE_ARGS += --disable-static
PATCHES_LEVEL = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: $(PKG_NAME)_pre_configure
$(PKG_NAME)_pre_configure:
	$(RUN) autoreconf -i -f -v -I $(INSTALL_DIR)$(INSTALL_PREFIX)/lib/aclocal

.PHONY: $(PKG_NAME)_post_configure_target
$(PKG_NAME)_post_configure_target:
	$(RUN) sed -i 's,^CFLAGS =.*,CFLAGS =,g' util/Makefile
	$(RUN) sed -i 's,^CPPFLAGS =.*,CPPFLAGS =,g' util/Makefile
