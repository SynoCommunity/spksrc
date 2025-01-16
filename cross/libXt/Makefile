PKG_NAME = libXt
PKG_VERS = 1.3.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.x.org/archive/individual/lib
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libX11

HOMEPAGE = https://www.x.org
COMMENT  = X.Org X11 libXt runtime library.
LICENSE  = GPLv2/GPLv3

POST_CONFIGURE_TARGET = libXt_post_configure_target

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --datarootdir=$(INSTALL_PREFIX)/lib
CONFIGURE_ARGS += --enable-malloc0returnsnull
CONFIGURE_ARGS += --without-xmlto
CONFIGURE_ARGS += --without-fop
CONFIGURE_ARGS += --disable-static

include ../../mk/spksrc.cross-cc.mk

.PHONY: libXt_post_configure_target
libXt_post_configure_target:
	@$(MSG) "Avoid invalid CPPFLAGS (for 32-bit ARM archs) in util folder"
	@$(RUN) sed -e 's,^CPPFLAGS =.*,CPPFLAGS =,g' -i.bak util/Makefile
