PKG_NAME = mysql
PKG_VERS = 5.1.49
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp15.us.freebsd.org/pub/FreeBSD/ports/distfiles
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncurses

HOMEPAGE = https://dev.mysql.com/downloads/mysql/
COMMENT  = MySQL Community Edition is a freely downloadable version of the world's most popular open source database that is supported by an active community of open source developers and enthusiasts.
LICENSE  =

PRE_CONFIGURE_TARGET = myPreConfigure
GNU_CONFIGURE = 1
CONFIGURE_ARGS = ac_cv_sys_restartable_syscalls=yes --with-low-memory --without-server --enable-static=yes --enable-shared=yes --without-debug --without-query-cache --without-man --without-docs --without-innodb --without-extra-tools

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	sed -i '/# either define HAVE_IB_GCC_ATOMIC_BUILTINS or not/{n; s/yes/no/}' $(WORK_DIR)/$(PKG_DIR)/configure
	sed -i '/# either define HAVE_IB_ATOMIC_PTHREAD_T_GCC or not/{n; s/yes/no/}' $(WORK_DIR)/$(PKG_DIR)/configure
	sed -i '/# either define HAVE_IB_ATOMIC_PTHREAD_T_SOLARIS or not/{n; s/yes/no/}' $(WORK_DIR)/$(PKG_DIR)/configure 