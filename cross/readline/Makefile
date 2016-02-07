PKG_NAME = readline
PKG_VERS = 6.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.gnu.org/gnu/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

include ../ncurses/which-ncurses.mk
DEPENDS = cross/ncurses

HOMEPAGE = http://www.gnu.org/s/readline
COMMENT  = Set of functions for use by applications that allow users to edit command lines as they are typed in.
LICENSE  = http://www.gnu.org/licenses/gpl.html

GNU_CONFIGURE = 1
CONFIGURE_ARGS = bash_cv_wcwidth_broken=no --disable-static --enable-shared

PATCH_TARGET = myPatch patch_target
COMPILE_TARGET = myCompile
#INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPatch
myPatch:
	$(RUN) sed -i '/MV.*old/d' Makefile.in && sed -i '/{OLDSUFF}/c:' support/shlib-install

.PHONY: myCompile
myCompile:
	$(RUN) make SHLIB_LIBS=-lncurses$(NCURSES_SUFFIX)

.PHONY: myInstall
myInstall:
	$(RUN) make SHLIB_LIBS=-lncurses$(NCURSES_SUFFIX) -j1 DESTDIR=$(STAGING_INSTALL_PREFIX) install

