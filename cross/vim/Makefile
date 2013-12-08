PKG_NAME = vim
PKG_VERS = 7.3
PKG_VERS_CUT = 73
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.vim.org/pub/vim/unix/
PKG_DIR = $(PKG_NAME)$(PKG_VERS_CUT)

DEPENDS = cross/ncurses

HOMEPAGE = http://www.vim.org/
COMMENT  = Vim is an advanced text editor that seeks to provide the power of the de-facto Unix editor Vi, with a more complete feature set.
LICENSE  = Charityware

GNU_CONFIGURE = 1
CONFIGURE_ARGS = vim_cv_toupper_broken=no --with-tlib=ncurses vim_cv_terminfo=yes vim_cv_tty_group=world vim_cv_getcwd_broken=yes vim_cv_stat_ignores_slash=yes vim_cv_memmove_handles_overlap=yes
ADDITIONAL_CFLAGS = 
PRE_CONFIGURE_TARGET = $(RUN) autoreconf

INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
