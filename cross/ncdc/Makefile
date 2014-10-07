PKG_NAME = ncdc
PKG_VERS = 1.19.1
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://dev.yorhel.nl/download

DEPENDS = cross/ncurses cross/ncursesw cross/zlib cross/glib cross/sqlite cross/gnutls cross/bzip2

HOMEPAGE = http://dev.yorhel.nl/ncdc
COMMENT  = Ncdc is a modern and lightweight direct connect client with a friendly ncurses interface.
LICENSE  = MIT

MAINTAINER = sirjeannot@gmail.com

GNU_CONFIGURE = 0

CONFIGURE_ARGS  = --prefix=/usr
ADDITIONAL_CFLAGS = -O3

include ../../mk/spksrc.cross-cc.mk
