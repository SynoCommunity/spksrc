PKG_NAME = ImageMagick
PKG_VERS = 6.9.5-10
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.imagemagick.org/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/freetype cross/libpng cross/libxml2 cross/libtiff cross/libjpeg

HOMEPAGE = http://www.imagemagick.org/
COMMENT  = ImageMagick is a software suite to create, edit, compose, or convert bitmap images.
LICENSE  = Apache 2.0

UNSUPPORTED_ARCHS = powerpc ppc824x

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --disable-installed --without-perl --without-x --without-fpx --without-wmf --disable-openmp


INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

myInstall:
	$(RUN) make install prefix=$(STAGING_INSTALL_PREFIX) \
	SHARE_PATH=$(STAGING_INSTALL_PREFIX)/share/ImageMagick-6/ \
	DATA_DIR=$(STAGING_INSTALL_PREFIX)/share/ImageMagick-6/ \
	CONFIGURE_PATH=$(STAGING_INSTALL_PREFIX)/etc/ImageMagick-6/ \
	LIBRARY_PATH=$(STAGING_INSTALL_PREFIX)/lib/ImageMagick-6.9.0/ \
	SHAREARCH_PATH=$(STAGING_INSTALL_PREFIX)/lib/ImageMagick-6.9.0/config-Q16 \
	DOCUMENTATION_PATH=$(STAGING_INSTALL_PREFIX)/share/doc/ImageMagick-6 \
	INCLUDE_PATH=$(STAGING_INSTALL_PREFIX)/include/ImageMagick-6 \
	INCLUDEARCH_PATH=$(STAGING_INSTALL_PREFIX)/include/ImageMagick-6
