PKG_NAME = ncdu
PKG_VERS = 1.17
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://dev.yorhel.nl/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# ncdu 2.x is written in Zig and needs a Zig compiler to build with.
DEPENDS = cross/ncursesw

HOMEPAGE = https://dev.yorhel.nl/ncdu
COMMENT  = Disk usage analyzer with an ncurses interface.
LICENSE  = MIT

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
