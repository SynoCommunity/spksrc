PKG_NAME = lcms2
PKG_VERS = 2.14
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mm2/Little-CMS/releases/download/lcms$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libtiff cross/libjpeg cross/zlib

HOMEPAGE = http://www.littlecms.com/
COMMENT  = Little CMS is a free, open source, CMM engine. It provides fast transforms between ICC profiles.
LICENSE  = MIT

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
