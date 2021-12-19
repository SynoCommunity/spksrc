PKG_NAME = ncdu
PKG_VERS = 1.16
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://dev.yorhel.nl/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw

HOMEPAGE = https://dev.yorhel.nl/ncdu
COMMENT  = Disk usage analyzer with an ncurses interface.
LICENSE  = MIT

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
