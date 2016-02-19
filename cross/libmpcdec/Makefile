PKG_NAME = libmpcdec
PKG_VERS = 1.2.6
PKG_EXT = tar.bz2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://files.musepack.net/source

DEPENDS = 

HOMEPAGE = http://musepack.net/
COMMENT  = Musepack SV7 decoder library
LICENSE  = BSD

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static --enable-shared

include ../../mk/spksrc.cross-cc.mk

