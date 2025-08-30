PKG_NAME = cairo
PKG_VERS = 1.16.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.cairographics.org/releases/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpng cross/freetype cross/pixman cross/fontconfig cross/glib

HOMEPAGE = https://www.cairographics.org
COMMENT  = Cairo is a 2D graphics library with support for multiple output devices.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static --disable-trace --enable-gobject
ADDITIONAL_CPPFLAGS = -O

# Use custom build and install targets, since configure does not support
# to disable the build of code in the sub folders: test, perf, boilderplate.
# But this needs a lot of build resources, and it will never run as we are
# cross compiling.
# This (old) blog shows, that it is not intended to enable test code skipping:
# https://lists.cairographics.org/archives/cairo/2014-July/025373.html
COMPILE_TARGET = cairo_compile
INSTALL_TARGET = cairo_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: cairo_compile
cairo_compile:
	@$(MSG) Build without tests
	@$(RUN) $(MAKE) -C src  $(COMPILE_MAKE_OPTIONS)
	@$(RUN) $(MAKE) -C util $(COMPILE_MAKE_OPTIONS)

.PHONY: cairo_install
cairo_install:
	@$(MSG) Install without building tests
	@$(RUN) $(MAKE) -C src  install DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX)
	@$(RUN) $(MAKE) -C util install DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX)
