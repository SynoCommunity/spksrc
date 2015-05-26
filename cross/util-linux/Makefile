PKG_NAME = util-linux
PKG_SHORT_VERS = 2.26
PKG_VERS = $(PKG_SHORT_VERS).2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.kernel.org/pub/linux/utils/util-linux/v$(PKG_SHORT_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/karelzak/util-linux
COMMENT  = Random collection of Linux utilities
LICENSE  = GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --without-ncurses --without-python
CONFIGURE_ARGS += --disable-all-programs --enable-schedutils --enable-libuuid

include ../../mk/spksrc.cross-cc.mk

