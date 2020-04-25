PKG_NAME = libdvdnav
PKG_VERS = 6.0.1
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.videolan.org/pub/videolan/$(PKG_NAME)/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libdvdread

HOMEPAGE = https://www.videolan.org/developers/libdvdnav.html
COMMENT  = libdvdnav is a library that allows easy use of sophisticated DVD navigation \
	   features such as DVD menus, multiangle playback and even interactive DVD games
LICENSE  = GPL

GNU_CONFIGURE = 1

CONFIGURE_ARGS = NDEBUG --enable-shared=yes --with-pic

include ../../mk/spksrc.cross-cc.mk

