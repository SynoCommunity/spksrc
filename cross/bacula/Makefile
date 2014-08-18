PKG_NAME = bacula
PKG_VERS = 5.2.13
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://heanet.dl.sourceforge.net/project/$(PKG_NAME)/$(PKG_NAME)/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/lzo cross/ncurses cross/zlib cross/openssl

HOMEPAGE = http://www.bacula.org/
COMMENT  = Bacula File Daemon
LICENSE  =

DESTDIR=$(INSTALL_DIR)

GNU_CONFIGURE = 1

# Compile
PRE_COMPILE_TARGET = myPreCompile

include ../../mk/spksrc.cross-cc.mk

myPreCompile:
	sed -e 's|^#define HAVE_CHFLAGS .*|#undef HAVE_CHFLAGS|' -i $(WORK_DIR)/$(PKG_DIR)/src/config.h

CFLAGS="-g -Wall"

CONFIGURE_ARGS = ac_cv_func_setpgrp_void=yes --enable-client-only --prefix=$(INSTALL_DIR)/$(INSTALL_PREFIX) --with-working-dir=$(INSTALL_PREFIX)/working --with-pid-dir=$(INSTALL_PREFIX)/working --sbindir=$(INSTALL_DIR)/$(INSTALL_PREFIX)/bin
