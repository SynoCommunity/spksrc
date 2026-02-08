PKG_NAME = pngcrush
PKG_VERS = 1.8.13
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/pmt/files/pngcrush/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpng

HOMEPAGE = https://pmt.sourceforge.io/pngcrush/
COMMENT  = Pngcrush is an optimizer for PNG (Portable Network Graphics) files.
LICENSE  = 3-clause BSD

CONFIGURE_TARGET = nop

COMPILE_MAKE_OPTIONS = -f Makefile-nolib LIBS="-L$(STAGING_INSTALL_PREFIX) -lpng -lz"
INSTALL_MAKE_OPTIONS = -f Makefile-nolib install DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX)

# libpng >= 1.6.41
# pngcrush.c:5523:46: error: ‘PNG_IGNORE_ADLER32’ undeclared (first use in this function)
ADDITIONAL_CFLAGS = -DPNG_SET_OPTION_SUPPORTED  -DPNG_DISABLE_ADLER32_CHECK_SUPPORTED

include ../../mk/spksrc.cross-cc.mk
