PKG_NAME = xstow
PKG_VERS = 1.1.1
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/majorkingleo/xstow/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw

# Toolchains lacking c++11
MIN_GCC_VERSION = 4.8.1

HOMEPAGE = https://github.com/majorkingleo/xstow#readme
COMMENT  = XStow is a replacement of GNU Stow written in C++. It supports all features of Stow with some extensions.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --with-curses

include ../../mk/spksrc.cross-cc.mk
