PKG_NAME = djvulibre
PKG_VERS = 3.5.28
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/djvu/files/DjVuLibre/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libjpeg cross/libtiff

HOMEPAGE = http://djvu.sourceforge.net/
COMMENT  = DjVu is a web-centric format for distributing documents and images.
LICENSE  = GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --disable-desktopfiles
CONFIGURE_ARGS += --disable-xmltools 

include ../../mk/spksrc.cross-cc.mk
