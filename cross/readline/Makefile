PKG_NAME = readline
PKG_VERS = 8.2.13
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/readline
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw

HOMEPAGE = https://tiswww.cwru.edu/php/chet/readline/rltop.html
COMMENT  = Set of functions for use by applications that allow users to edit command lines as they are typed in.
LICENSE  = GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --disable-install-examples
CONFIGURE_ARGS += --with-curses=ncursesw
CONFIGURE_ARGS += --with-shared-termcap-library=-lncursesw
ADDITIONAL_CFLAGS = -O

POST_COMPILE_TARGET = readline_post_compile

include ../../mk/spksrc.cross-cc.mk

.PHONY: readline_post_compile
# The configure script does not handle ncursesw correctly
# - it adds ncurses dependency to the pkgconfig file even when statically linked (the default)
# - the dependency in the pkgconfig file is ncurses instead of ncursesw 
# we could patch the configure file but it is easier to patch the created pkgconfig file.
readline_post_compile:
	@$(RUN) sed 's/Requires.private: ncurses/Requires.private: ncursesw/' -i readline.pc
