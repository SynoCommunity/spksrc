PKG_NAME = ImageMagick
PKG_VERS = 7.1.0-35
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ImageMagick/ImageMagick/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

OPTIONAL_DEPENDS = cross/libheif

DEPENDS += cross/jemalloc
DEPENDS += cross/bzip2 cross/xz cross/libxml2
DEPENDS += cross/freetype cross/fontconfig
DEPENDS += cross/libtool cross/urw-base35-fonts
DEPENDS += cross/libpng cross/libjpeg cross/openjpeg
DEPENDS += cross/libtiff
DEPENDS += cross/libwmf
DEPENDS += cross/libwebp
DEPENDS += cross/zstd

include ../../mk/spksrc.archs.mk
ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS += cross/libheif
endif

HOMEPAGE = https://www.imagemagick.org/
COMMENT  = ImageMagick is a software suite to create, edit, compose, or convert bitmap images.
LICENSE  = Apache 2.0

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --disable-installed --disable-docs --disable-static
CONFIGURE_ARGS += --without-perl --without-x --without-fpx
# magick *++* files fail to add to package by PLIST
CONFIGURE_ARGS += --without-magick-plus-plus
CONFIGURE_ARGS += --with-jemalloc
CONFIGURE_ARGS += --with-modules
CONFIGURE_ARGS += --with-urw-base35-font-dir==$(INSTALL_PREFIX)/share/fonts
CONFIGURE_ARGS += --with-windows-font-dir=$(INSTALL_PREFIX)/share/libwmf/fonts

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
# ARMv5 and PPC archs (except QorIQ) have older kernels
# linking to lib rt fixes unreferenced clock_gettime
CONFIGURE_ARGS += CFLAGS=-lrt
endif

ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
