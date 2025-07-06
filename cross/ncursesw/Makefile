PKG_NAME = ncursesw
DIST_NAME = ncurses
PKG_VERS = 6.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(DIST_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/pub/gnu/ncurses
PKG_DIR = $(DIST_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://invisible-island.net/ncurses
COMMENT  = The NCURSES (new curses) library is a free software emulation of curses in System V Release 4.0, and more.
LICENSE  = GPLv3

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --with-shared
CONFIGURE_ARGS += --with-terminfo-dirs=$(INSTALL_PREFIX)/share/terminfo
CONFIGURE_ARGS += --with-pkg-config-libdir=$(INSTALL_PREFIX)/lib/pkgconfig
CONFIGURE_ARGS += --without-manpages
CONFIGURE_ARGS += --without-tests
CONFIGURE_ARGS += --without-debug
CONFIGURE_ARGS += --enable-rpath
CONFIGURE_ARGS += --enable-overwrite
CONFIGURE_ARGS += --enable-pc-files
CONFIGURE_ARGS += --disable-stripping
CONFIGURE_ARGS += --disable-home-terminfo
# Specific for ncursesw
CONFIGURE_ARGS += --enable-widec
CONFIGURE_ARGS += --without-normal

# optional create lib tinfow:
ifeq ($(strip $(NCURSES_WITH_TINFO)),yes)
# create lib tinfo:
CONFIGURE_ARGS += --with-termlib
else
PLIST_TRANSFORM = sed -e '/libtinfow/d'
endif

include ../../mk/spksrc.cross-cc.mk

# Known issues:
#   1) PKG_CONFIG_LIBDIR needs to be relative to DESTDIR (ref.: export below)
#   2) PKG_CONFIG_LIBDIR not considered without --with-pkg-config-libdir
#   3) PKG_CONFIG_LIBDIR overrides --with-pkg-config-libdir
#   4) --with-pkg-config-libdir value not important as overriden by PKG_CONFIG_LIBDIR
export PKG_CONFIG_LIBDIR=$(INSTALL_PREFIX)/lib/pkgconfig
