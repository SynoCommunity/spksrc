PKG_NAME = leptonica
PKG_VERS = 1.72
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://leptonica.org/source
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/libpng cross/libjpeg cross/libtiff cross/giflib

HOMEPAGE = http://www.leptonica.com
COMMENT = Leptonica is a pedagogically-oriented open source software that is broadly useful for image processing and image analysis applications.
LICENSE = http://www.leptonica.com/about-the-license.html

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static

include ../../mk/spksrc.cross-cc.mk

