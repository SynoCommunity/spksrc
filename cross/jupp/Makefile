PKG_NAME = jupp
PKG_VERS = 41
PKG_EXT = tgz
PKG_DIST_NAME = joe-3.1$(PKG_NAME)$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.mirbsd.org/MirOS/dist/jupp
PKG_DIR = $(PKG_NAME)

HOMEPAGE = http://www.mirbsd.org/jupp.htm
DESCRIPTION = jupp - the Editor which sucks less.
LICENSE = GPLv1

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-termidx

PRE_CONFIGURE_TARGET = jupp_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: jupp_pre_configure
jupp_pre_configure:
	chmod +x $(WORK_DIR)/$(PKG_NAME)/configure
