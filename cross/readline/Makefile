PKG_NAME = readline
PKG_VERS = 8.2
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
ADDITIONAL_CFLAGS = -O

POST_INSTALL_TARGET = readline_post_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: readline_post_install
readline_post_install:
	$(RUN) sed -i 's/Requires.private: ncurses/Requires.private: ncursesw/' readline.pc
	$(RUN) install -m 644 readline.pc $(STAGING_INSTALL_PREFIX)/lib/pkgconfig
