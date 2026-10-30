PKG_NAME = bind
PKG_VERS = 9.18.50
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.isc.org/isc/bind9/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# REMARKS:
# BIND 9:
# Even version numbers are stable versions (9.16, 9.18, 9.20) with support until EOL
# Odd version numbers are development versions (9.17, 9.19, 9.21)

DEPENDS  = cross/libuv
DEPENDS += cross/liburcu
DEPENDS += cross/openssl3
DEPENDS += cross/readline
DEPENDS += cross/jemalloc
DEPENDS += cross/libxml2
DEPENDS += cross/nghttp2
DEPENDS += cross/libcap

# lacking support for atomics:
# netmgr/udp.c uses the C11 _Atomic qualifier, which gcc has from 4.9:
#   udp.c:813: error: expected declaration specifiers before 'last_udpsends_log'
MIN_GCC_VERSION = 4.9


HOMEPAGE = https://www.isc.org/
COMMENT  = BIND (Berkeley Internet Name Domain) is a complete, highly portable implementation of the DNS (Domain Name System) protocol.
LICENSE  = MPL 2.0

GNU_CONFIGURE = 1
PRE_COMPILE_TARGET = bind_pre_compile

ADDITIONAL_CFLAGS = -O2
ADDITIONAL_CPPFLAGS = -O2

CONFIGURE_ARGS  = --enable-full-report
# Nothing is named for the build machine: configure.ac uses AX_PROG_CC_FOR_BUILD, which
# reads CC_FOR_BUILD and the *_FOR_BUILD flags the toolchain now supplies. The BUILD_CC
# this used to pass was never read -- that spelling is bind 9.16's.

include ../../mk/spksrc.cross-cc.mk

.PHONY: bind_pre_compile
# libns and libisccfg must be available in the install location at compile time
# otherwise the compilation of some binaries (rndc, dig, tools, ...) fails
# This is a workaround, since the solution with --rpath and --rpath-link did not work.
bind_pre_compile:
	@$(MSG) PRE-Compile start
	@$(MSG) Compile and install required libraries first
	@$(RUN) $(MAKE) -C lib
	@$(RUN) cp -f lib/ns/.libs/libns*.so $(STAGING_INSTALL_PREFIX)/lib/
	@$(RUN) cp -f lib/isccfg/.libs/libisccfg*.so $(STAGING_INSTALL_PREFIX)/lib/
	@$(MSG) PRE-Compile done
