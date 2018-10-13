PKG_NAME = libbluray
PKG_VERS = 1.0.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.videolan.org/pub/videolan/libbluray/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libxml2 cross/freetype cross/fontconfig

HOMEPAGE = http://www.videolan.org/developers/libbluray.html
COMMENT  = libbluray is an open-source library designed for Blu-Ray Discs playback for media players.
LICENSE  = LGPL

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --disable-examples --disable-doxygen-doc --disable-doxygen-dot --disable-bdjava-jar

include ../../mk/spksrc.cross-cc.mk

