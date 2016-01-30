PKG_NAME = mc
PKG_VERS = 4.8.15
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.midnight-commander.org/downloads
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/glib cross/ncursesw cross/slang

HOMEPAGE = http://www.midnight-commander.org
COMMENT  = GNU Midnight Commander is a visual file manager.  It\\\'s a feature rich full-screen text mode application that allows you to copy, move and delete files and whole directory trees, search for files and run commands in the subshell. Internal viewer and editor are included.
LICENSE  = GNU GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = fu_cv_sys_stat_statfs2_bsize=yes --with-screen=ncurses
ADDITIONAL_CFLAGS = -O3


INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
