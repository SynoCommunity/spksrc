PKG_NAME = imlib2
PKG_VERS = 1.4.7
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/enlightenment/files/$(PKG_NAME)-src/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/freetype cross/libpng cross/libjpeg cross/giflib cross/libtiff

HOMEPAGE = http://docs.enlightenment.org/api/imlib2/html/
COMMENT  = Imlib 2 library does image file loading and saving as well as rendering, manipulation, arbitrary polygon support, etc. 
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --without-x

include ../../mk/spksrc.cross-cc.mk
