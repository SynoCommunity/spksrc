PKG_NAME = rtorrent
PKG_VERS = 0.10.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/rakshasa/rtorrent/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw cross/libsigc++ cross/curl cross/libtorrent-rakshasa cross/xmlrpc-c

HOMEPAGE = https://rakshasa.github.com
COMMENT  = rTorrent is a BitTorrent client for ncurses, using the libtorrent library. The client and library is written in C++ with emphasis on speed and efficiency, while delivering equivalent features to those found in GUI based clients in an ncurses client.
LICENSE  = GPL

# Requires compiler with C++14 support
REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k
REQUIRED_MIN_SRM = 1.3

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = rtorrent_pre_configure
PRE_PATCH_TARGET = rtorrent_pre_patch
PRE_COMPILE_TARGET = rtorrent_pre_compile

CONFIGURE_ARGS = --with-xmlrpc-c=$(STAGING_INSTALL_PREFIX)/bin/xmlrpc-c-config

include ../../mk/spksrc.cross-cc.mk

.PHONY: rtorrent_pre_configure
rtorrent_pre_configure:
	cp src/linux-atomic.c $(WORK_DIR)/$(PKG_DIR)/src

.PHONY: rtorrent_pre_patch
rtorrent_pre_patch:
	@$(RUN) autoreconf -fi

.PHONY: rtorrent_pre_compile
rtorrent_pre_compile:
	@$(RUN) libtool --tag=CC --mode=compile $(TC_PATH)$(TC_PREFIX)gcc -g -O2 -MT src/linux-atomic.lo -MD -MP -MF src/linux-atomic.Tpo -c -o src/linux-atomic.lo src/linux-atomic.c
	@$(RUN) libtool --tag=CC --mode=link $(TC_PATH)$(TC_PREFIX)gcc -g -O2 -o src/liblinux-atomic.la src/linux-atomic.lo
