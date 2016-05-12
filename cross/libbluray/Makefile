PKG_NAME = libbluray
PKG_VERS = 0.9.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.videolan.org/pub/videolan/libbluray/0.9.2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libxml2 cross/freetype cross/fontconfig

HOMEPAGE =
COMMENT  =
LICENSE  =

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --disable-examples --disable-doxygen-doc --disable-doxygen-dot

include ../../mk/spksrc.cross-cc.mk

