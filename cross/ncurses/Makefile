PKG_NAME = ncurses
PKG_VERS = 6.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/pub/gnu/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://invisible-island.net/ncurses
COMMENT  = The NCURSES (new curses) library is a free software emulation of curses in System V Release 4.0, and more.
LICENSE  = GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --with-shared --enable-rpath --without-manpages --without-tests --enable-overwrite --disable-widec
CONFIGURE_ARGS += --disable-home-terminfo --enable-pc-files --with-pkg-config-libdir=$(INSTALL_PREFIX)/lib/pkgconfig
CONFIGURE_ARGS += --disable-stripping --with-terminfo-dirs=$(INSTALL_PREFIX)/share/terminfo

include ../../mk/spksrc.cross-cc.mk
