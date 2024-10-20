PKG_NAME = ImageMagick
PKG_VERS = 7.1.1-33
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ImageMagick/ImageMagick/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

OPTIONAL_DEPENDS = cross/libheif cross/libraw cross/openexr cross/libraqm cross/librsvg

DEPENDS  = cross/jemalloc
DEPENDS += cross/bzip2 
DEPENDS += cross/xz
DEPENDS += cross/zstd
DEPENDS += cross/libxml2
DEPENDS += cross/freetype
DEPENDS += cross/fontconfig
DEPENDS += cross/urw-base35-fonts
DEPENDS += cross/dejavu
DEPENDS += cross/openjpeg
DEPENDS += cross/libjpeg
DEPENDS += cross/jbigkit
DEPENDS += cross/libpng
DEPENDS += cross/libtiff
DEPENDS += cross/libwmf
DEPENDS += cross/libwebp
DEPENDS += cross/djvulibre
DEPENDS += cross/libtool
DEPENDS += cross/libfpx
DEPENDS += cross/fftw

CONFIGURE_ARGS  = --disable-installed --disable-docs --disable-static
CONFIGURE_ARGS += --without-perl --without-x
# magick *++* files fail to add to package by PLIST
CONFIGURE_ARGS += --without-magick-plus-plus

include ../../mk/spksrc.common.mk
SUPPORT_CPP11 = 1
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
SUPPORT_CPP11 = 0
endif
ifeq ($(call version_lt, $(TCVERSION), 6.0)$(call version_ge, $(TCVERSION), 3.0),11)
SUPPORT_CPP11 = 0
endif

ifeq ($(SUPPORT_CPP11),1)
DEPENDS += cross/libheif
DEPENDS += cross/libraw
DEPENDS += cross/openexr
DEPENDS += cross/libraqm
DEPENDS += cross/librsvg
CONFIGURE_ARGS += --with-rsvg
endif

HOMEPAGE = https://www.imagemagick.org/
COMMENT  = ImageMagick is a software suite to create, edit, compose, or convert bitmap images.
LICENSE  = Apache 2.0

GNU_CONFIGURE = 1

CONFIGURE_ARGS += --with-fpx
CONFIGURE_ARGS += --with-fftw
CONFIGURE_ARGS += --with-jemalloc
CONFIGURE_ARGS += --with-modules
CONFIGURE_ARGS += --with-dejavu-font-dir=$(INSTALL_PREFIX)/share/dejavu/fonts
CONFIGURE_ARGS += --with-urw-base35-font-dir=$(INSTALL_PREFIX)/share/fonts
CONFIGURE_ARGS += --with-windows-font-dir=$(INSTALL_PREFIX)/share/libwmf/fonts

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
# ARMv5 and PPC archs (except QorIQ) have older kernels
# linking to lib rt fixes unreferenced clock_gettime
CONFIGURE_ARGS += CFLAGS=-lrt
endif

ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk
