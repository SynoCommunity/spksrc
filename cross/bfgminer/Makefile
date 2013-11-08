PKG_NAME = bfgminer
PKG_VERS = 3.3.0
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://luke.dashjr.org/programs/bitcoin/files/$(PKG_NAME)/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/curl cross/libjansson

HOMEPAGE = https://github.com/luke-jr/bfgminer
COMMENT  = This is a multi-threaded multi-pool ASIC, FPGA, GPU and CPU miner with dynamic clocking, monitoring, and fanspeed support for bitcoin. Do not use on multiple block chains at the same time! (!!! Cpumining is disabled in this package !!!)
LICENSE  = 

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = myPreConfigure
CONFIGURE_ARGS = --disable-cpumining --without-curses

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) autoconf
