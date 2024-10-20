PKG_NAME = imlib2
PKG_VERS = 1.12.3
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/enlightenment/files/imlib2-src/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/freetype cross/libpng cross/libjpeg cross/giflib cross/libtiff cross/libwebp

HOMEPAGE = https://docs.enlightenment.org/api/imlib2/html/
COMMENT  = Imlib 2 library does image file loading and saving as well as rendering, manipulation, arbitrary polygon support, etc. 
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --without-x
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
ADDITIONAL_LDFLAGS = -lrt 
endif

include ../../mk/spksrc.cross-cc.mk
