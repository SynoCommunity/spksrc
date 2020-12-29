PKG_NAME = rtorrent
PKG_VERS = 0.9.8
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/rakshasa/rtorrent/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# PPC archs except qoriq
UNSUPPORTED_ARCHS = $(OLD_PCC_ARCHS)

# error: template instantiation depth exceeds maximum of 900 (requires gcc >= 4.9)
# see: https://github.com/rakshasa/rtorrent/issues/223
UNSUPPORTED_ARCHS += $(ARMv7L_ARCHS)

DEPENDS = cross/ncursesw cross/libsigc++ cross/curl cross/libtorrent-rakshasa cross/xmlrpc-c

HOMEPAGE = https://rakshasa.github.com
COMMENT  = rTorrent is a BitTorrent client for ncurses, using the libtorrent library. The client and library is written in C++ with emphasis on speed and efficiency, while delivering equivalent features to those found in GUI based clients in an ncurses client.
LICENSE  = GPL

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = rtorrent_pre_configure
PRE_PATCH_TARGET = rtorrent_pre_patch
COMPILE_TARGET = rtorrent_compile

CONFIGURE_ARGS = --with-xmlrpc-c=$(STAGING_INSTALL_PREFIX)/bin/xmlrpc-c-config

include ../../mk/spksrc.cross-cc.mk

.PHONY: rtorrent_pre_configure
rtorrent_pre_configure:
	cp src/linux-atomic.c $(WORK_DIR)/$(PKG_DIR)/src

.PHONY: rtorrent_pre_patch
rtorrent_pre_patch:
	@$(RUN) ./autogen.sh

.PHONY: rtorrent_compile
rtorrent_compile:
	@$(RUN) ./libtool --tag=CC --mode=compile $(TC_PATH)$(TC_PREFIX)gcc -g -O2 -MT src/linux-atomic.lo -MD -MP -MF src/linux-atomic.Tpo -c -o src/linux-atomic.lo src/linux-atomic.c
	@$(RUN) ./libtool --tag=CC --mode=link $(TC_PATH)$(TC_PREFIX)gcc -g -O2 -o src/liblinux-atomic.la src/linux-atomic.lo
	@$(RUN) $(MAKE)
