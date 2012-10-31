PKG_NAME = mc
PKG_VERS = 4.8.6
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.midnight-commander.org/downloads
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
SRC_DIR= $(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS)/

DEPENDS = cross/glib cross/ncurses

HOMEPAGE = http://www.midnight-commander.org/
COMMENT  = GNU Midnight Commander is a visual file manager.  It\\\'s a feature rich full-screen text mode application that allows you to copy, move and delete files and whole directory trees, search for files and run commands in the subshell. Internal viewer and editor are included.
LICENSE  = GNU GPL

CONFIGURE_TARGET = myConfigure

include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure: 
	@$(RUN) ln -sf $(INSTALL_DIR)/$(INSTALL_PREFIX)/include $(INSTALL_DIR)/$(INSTALL_PREFIX)/include/ncurses
	$(RUN) fu_cv_sys_stat_statfs2_bsize=yes ac_cv_search_has_colors="-lncursesw" CFLAGS="$(CFLAGS) -I$(INSTALL_DIR)/$(INSTALL_PREFIX)/include/glib-2.0 -O1" LDFLAGS="$(LDFLAGS) -lglib-2.0" GMODULE_LIBS="-pthread -L$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib -lrt" GLIB_LIBS="-Lglib-2.0 -Lgmodule-2.0" ./configure --prefix=$(INSTALL_PREFIX) --with-screen=ncurses --without-gpm-mouse --with-glib-static --without-x

	# $(RUN) GLIB=$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib fu_cv_sys_stat_statfs2_bsize=yes ac_cv_search_has_colors="-lncursesw" GLIB=glib-2.0 GLIB_CFLAGS="-Iglib-2.0" GLIB_LIBS="-Lglib-2.0" GMODULE_CFLAGS="-Iglib-2.0" GMODULE_LIBS="-Lgli" CFLAGS="$(CFLAGS) -O1 $(GLIB_CFLAGS) $(GMODULE_CFLAGS)" LDFLAGS="$(LDFLAGS) $(GLIB_LIBS) $(GMODULE_LIBS)" LIBS="-lglib-2.0 -lgmodule-2.0" ./configure --prefix=$(INSTALL_PREFIX) --with-screen=ncurses --without-gpm-mouse --with-glib-static --without-x



