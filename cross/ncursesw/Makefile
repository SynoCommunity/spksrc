PKG_NAME_M = ncurses
PKG_NAME = $(PKG_NAME_M)w
PKG_VERS = 6.0
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME_M)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnu.org/pub/gnu/$(PKG_NAME_M)

DEPENDS =
# Default: activate NCursesW
NCURSES_SUFFIX = w
# Check if ncurses(w) build already started
include ../ncurses/which-ncurses.mk
ifneq ($(NCURSES_SUFFIX),w)
  DEPENDS += cross/ncurses
  include ../ncurses/dummy-pkg.mk
endif

HOMEPAGE = http://www.gnu.org/s/ncurses
COMMENT  = The Ncurses (new curses) library is a free software emulation of curses in System V Release 4.0, and more.
LICENSE  = http://www.gnu.org/licenses/gpl.html

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --with-shared --enable-rpath --without-manpages --without-tests --enable-overwrite
CONFIGURE_ARGS += --disable-home-terminfo --with-default-terminfo-dir=$(STAGING_INSTALL_PREFIX)/share/terminfo
CONFIGURE_ARGS += --with-terminfo-dirs=$(INSTALL_PREFIX)/share/terminfo
CONFIGURE_ARGS += --without-normal --enable-pc-files  --with-pkg-config-libdir=$(PKG_CONFIG_LIBDIR)
CONFIGURE_ARGS += --enable-widec

include ../../mk/spksrc.cross-cc.mk

