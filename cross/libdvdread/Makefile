PKG_NAME = libdvdread
PKG_VERS = 6.0.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.videolan.org/pub/videolan/$(PKG_NAME)/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = https://www.videolan.org/developers/libdvdnav.html
COMMENT  = libdvdread is a library that allows easy use of simple DVD navigation.
LICENSE  = GPL

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --enable-dlfcn --enable-shared=yes --with-pic

include ../../mk/spksrc.cross-cc.mk

