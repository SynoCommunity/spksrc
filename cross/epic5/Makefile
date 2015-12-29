PKG_NAME = epic5
PKG_VERS = 1.4
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl cross/ncurses

HOMEPAGE = http://www.epicsol.org/
COMMENT  = Internet Relay Chat client for UNIX like systems
LICENSE  = BSD

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-ipv6 --with-ssl --with-wserv
CONFIGURE_ARGS += ac_cv_func_getpgrp_void=yes
ADDITIONAL_CFLAGS = -O1 -Os -DSYS_SIGLIST_DECLARED=1

PRE_CONFIGURE_TARGET = myPreConfigure

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) autoconf
