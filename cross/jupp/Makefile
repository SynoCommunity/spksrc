PKG_NAME = jupp
PKG_VERS = 30
PKG_EXT = tgz
PKG_DIST_NAME = joe-3.1$(PKG_NAME)$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.mirbsd.org/MirOS/dist/jupp
PKG_DIR = $(PKG_NAME)

HOMEPAGE = https://www.mirbsd.org/jupp.htm
LICENSE  = GPLv1

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-termidx
PRE_CONFIGURE_TARGET = chmod_755_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: chmod_755_configure
chmod_755_configure:
	chmod 755 $(WORK_DIR)/$(PKG_NAME)/configure
