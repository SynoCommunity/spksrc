PKG_NAME = htop
PKG_VERS = 1.0.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://hisham.hm/htop/releases/1.0.3
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncurses

HOMEPAGE = http://hisham.hm/htop/
COMMENT  = An interactive process viewer for Linux
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-unicode

include ../../mk/spksrc.cross-cc.mk
