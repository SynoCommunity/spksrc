PKG_NAME = tiff
PKG_VERS = 4.6.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://download.osgeo.org/libtiff
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libjpeg cross/zlib cross/zstd

HOMEPAGE = https://gitlab.com/libtiff/libtiff
COMMENT  = LibTIFF provides support for the Tag Image File Format (TIFF), a widely used format for storing image data.
LICENSE  = No license. All rights reserved.

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-rpath --disable-static
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
