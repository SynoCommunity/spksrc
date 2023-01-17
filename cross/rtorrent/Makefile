PKG_NAME = rtorrent
PKG_VERS = 0.9.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/rakshasa/rtorrent/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

UNSUPPORTED_ARCHS = powerpc ppc824x ppc854x

DEPENDS = cross/ncurses cross/libsigc++ cross/curl cross/libtorrent-rakshasa cross/xmlrpc-c

HOMEPAGE = https://rakshasa.github.com
COMMENT  = rTorrent is a BitTorrent client for ncurses, using the libtorrent library. The client and library is written in C++ with emphasis on speed and efficiency, while delivering equivalent features to those found in GUI based clients in an ncurses client.
LICENSE  = GPL

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = myPreConfigure
PRE_PATCH_TARGET = myPrePatch
COMPILE_TARGET = myCompile

CONFIGURE_ARGS = --with-xmlrpc-c=$(STAGING_INSTALL_PREFIX)/bin/xmlrpc-c-config

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	cp src/linux-atomic.c $(WORK_DIR)/$(PKG_DIR)/src

.PHONY: myPrePatch
myPrePatch:
	@$(RUN) ./autogen.sh

.PHONY: myCompile
myCompile:
	@$(RUN) ./libtool --tag=CC --mode=compile $(TC_PATH)$(TC_PREFIX)gcc -g -O2 -MT src/linux-atomic.lo -MD -MP -MF src/linux-atomic.Tpo -c -o src/linux-atomic.lo src/linux-atomic.c
	@$(RUN) ./libtool --tag=CC --mode=link $(TC_PATH)$(TC_PREFIX)gcc -g -O2 -o src/liblinux-atomic.la src/linux-atomic.lo
	@$(RUN) $(MAKE)
