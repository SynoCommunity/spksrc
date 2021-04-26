PKG_NAME = ImageMagick
PKG_VERS = 7.0.11-6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ImageMagick/ImageMagick/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/freetype cross/libpng cross/libxml2 cross/libtiff cross/libjpeg

HOMEPAGE = https://www.imagemagick.org/
COMMENT  = ImageMagick is a software suite to create, edit, compose, or convert bitmap images.
LICENSE  = Apache 2.0

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-installed --without-perl --without-x --without-fpx --without-wmf --disable-openmp

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
# ARMv5 and PPC archs (except QorIQ) have older kernels
# linking to lib rt fixes unreferenced clock_gettime
CONFIGURE_ARGS += CFLAGS=-lrt
endif

