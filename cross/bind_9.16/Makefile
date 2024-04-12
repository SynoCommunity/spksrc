PKG_NAME = bind
PKG_VERS = 9.16.45
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.isc.org/isc/bind9/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# This is the latest version that builds for ARMv5 archs.

DEPENDS = cross/libuv
DEPENDS += cross/openssl3
DEPENDS += cross/readline
DEPENDS += cross/jemalloc
DEPENDS += cross/libxml2

OPTIONAL_DEPENDS = cross/libcap cross/libcap_2.51

# by cross/libuv
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
DEPENDS += cross/libcap_2.51
else
DEPENDS += cross/libcap
endif

HOMEPAGE = https://www.isc.org/
COMMENT  = BIND (Berkeley Internet Name Domain) is a complete, highly portable implementation of the DNS (Domain Name System) protocol.
LICENSE  = MPL 2.0

GNU_CONFIGURE = 1
PRE_COMPILE_TARGET = bind_pre_compile

ADDITIONAL_CFLAGS = -O2
ADDITIONAL_CPPFLAGS = -O2

CONFIGURE_ARGS  = --without-python
CONFIGURE_ARGS += --enable-full-report
# needed for cross compile:
CONFIGURE_ARGS += BUILD_CC="$(CC)"
CONFIGURE_ARGS += BUILD_CFLAGS="$(CFLAGS) $(ADDITIONAL_CFLAGS)"
CONFIGURE_ARGS += BUILD_CPPFLAGS="$(CPPFLAGS) $(ADDITIONAL_CPPFLAGS)"
CONFIGURE_ARGS += BUILD_LDFLAGS="$(LDFLAGS)"
CONFIGURE_ARGS += BUILD_LIBS="$(LIBS)"

include ../../mk/spksrc.cross-cc.mk

.PHONY: bind_pre_compile
bind_pre_compile:
	@$(MSG) Build gen tool for host
	# compile gen tool with host compiler to run in build environment
	cd $(WORK_DIR)/$(PKG_DIR)/lib/dns; gcc -I../../lib/isc/include -o gen ./gen.c
