PKG_NAME = lcms2
PKG_VERS = 2.11
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE =  https://github.com/mm2/Little-CMS/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = Little-CMS-$(PKG_VERS)

DEPENDS = cross/libtiff cross/libjpeg cross/zlib

HOMEPAGE = http://www.littlecms.com/
COMMENT  = Little CMS is a free, open source, CMM engine. It provides fast transforms between ICC profiles.
LICENSE  = MIT

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
