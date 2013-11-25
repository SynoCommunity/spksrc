PKG_NAME = rtorrent
PKG_VERS = 0.9.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://libtorrent.rakshasa.no/downloads
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncurses cross/libsigc++ cross/curl cross/libtorrent-rakshasa cross/xmlrpc-c

HOMEPAGE = http://libtorrent.rakshasa.no/
COMMENT  = rTorrent is a BitTorrent client for ncurses, using the libtorrent library. The client and library is written in C++ with emphasis on speed and efficiency, while delivering equivalent features to those found in GUI based clients in an ncurses client.
LICENSE  = GPL

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = myPreConfigure
COMPILE_TARGET = myCompile

CONFIGURE_ARGS = --with-xmlrpc-c=$(STAGING_INSTALL_PREFIX)/bin/xmlrpc-c-config

# Limit to supported archs
ifeq ($(findstring $(ARCH),88f5281 powerpc ppc824x ppc853x ppc854x),$(ARCH))
$(error $(ARCH) is not a supported architecture)
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	cp src/linux-atomic.c $(WORK_DIR)/$(PKG_DIR)/src

.PHONY: myCompile
myCompile:
	@$(RUN) ; libtool --tag=CC --mode=compile $(TC_PATH)$(TC_PREFIX)gcc -g -O2 -MT src/linux-atomic.lo -MD -MP -MF src/linux-atomic.Tpo -c -o src/linux-atomic.lo src/linux-atomic.c
	@$(RUN) ; libtool --tag=CC --mode=link $(TC_PATH)$(TC_PREFIX)gcc -g -O2 -o src/liblinux-atomic.la src/linux-atomic.lo
	@$(RUN) ; $(MAKE)
