# use a different package name (directory) for cross/ncursesw
# than for cross/ncurses to build into independent folders.
PKG_NAME = ncursesw
DIST_NAME = ncurses
PKG_VERS = 6.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(DIST_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/pub/gnu/$(DIST_NAME)
EXTRACT_PATH = $(WORK_DIR)/temp
DIST_TARGET_DIR = $(DIST_NAME)-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://invisible-island.net/ncurses
COMMENT  = The NCURSES (new curses) library is a free software emulation of curses in System V Release 4.0, and more.
LICENSE  = GPLv3

POST_EXTRACT_TARGET = ncursesw_post_extract

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --with-shared --enable-rpath --without-manpages --without-tests --enable-overwrite --enable-widec
CONFIGURE_ARGS += --disable-home-terminfo --without-normal --enable-pc-files --with-pkg-config-libdir=$(INSTALL_PREFIX)/lib/pkgconfig
CONFIGURE_ARGS += --disable-stripping --with-terminfo-dirs=$(INSTALL_PREFIX)/share/terminfo

include ../../mk/spksrc.cross-cc.mk

.PHONY: ncursesw_post_extract
# Dist name and extracted package are the same for ncursesw and ncurses
# We need a different folder for ncursesw here, since there exists spk that
# include packages depending on ncurses and packages depending on ncursesw
# (like synocli-file)
# We get a different PKG_DIR for ncursesw by extracting to a temp folder
# and then rename the target folder to ncursesw-$(PKG_VERS)
# The temp folder is needed to be independent whether ncurses or ncursesw
# is built first.
ncursesw_post_extract:
	@cd $(WORK_DIR) && mv temp/$(DIST_TARGET_DIR) $(PKG_DIR) && rm -rf temp
