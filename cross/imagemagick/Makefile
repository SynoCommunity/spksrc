PKG_NAME = ImageMagick
PKG_VERS = 7.0.8-53
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
INSTALL_TARGET = imagemagick_install

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
# ARMv5 and PPC archs (except QorIQ) have older kernels
# linking to lib rt fixes unreferenced clock_gettime
CONFIGURE_ARGS += CFLAGS=-lrt
endif

.PHONY: imagemagick_install
imagemagick_install:
	$(RUN) make install prefix=$(STAGING_INSTALL_PREFIX) \
	SHARE_PATH=$(STAGING_INSTALL_PREFIX)/share/ImageMagick-7/ \
	DATA_DIR=$(STAGING_INSTALL_PREFIX)/share/ImageMagick-7/ \
	CONFIGURE_PATH=$(STAGING_INSTALL_PREFIX)/etc/ImageMagick-6/ \
	LIBRARY_PATH=$(STAGING_INSTALL_PREFIX)/lib/ImageMagick-7.0.8/ \
	SHAREARCH_PATH=$(STAGING_INSTALL_PREFIX)/lib/ImageMagick-7.0.7/config-Q16 \
	DOCUMENTATION_PATH=$(STAGING_INSTALL_PREFIX)/share/doc/ImageMagick-7 \
	INCLUDE_PATH=$(STAGING_INSTALL_PREFIX)/include/ImageMagick-7 \
	INCLUDEARCH_PATH=$(STAGING_INSTALL_PREFIX)/include/ImageMagick-7
