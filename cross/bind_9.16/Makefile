PKG_NAME = bind
PKG_VERS = 9.16.50
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.isc.org/isc/bind9/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# This is the latest version that builds for ARMv5_ARCHS, ARMv7L_ARCHS and x86-5.2

DEPENDS  = cross/libuv_1.34
DEPENDS += cross/openssl3
DEPENDS += cross/readline
DEPENDS += cross/jemalloc
DEPENDS += cross/libxml2
DEPENDS += cross/libcap

HOMEPAGE = https://www.isc.org/
COMMENT  = BIND (Berkeley Internet Name Domain) is a complete, highly portable implementation of the DNS (Domain Name System) protocol.
LICENSE  = MPL 2.0

GNU_CONFIGURE = 1

ADDITIONAL_CFLAGS = -O2
ADDITIONAL_CPPFLAGS = -O2

CONFIGURE_ARGS  = --without-python
CONFIGURE_ARGS += --enable-full-report
# gen is compiled and run on the build machine, so it takes the build compiler and none of
# the target's flags; configure.ac errors out if BUILD_CC is unset when cross compiling,
# and takes the other four verbatim. $(CC) was not the cross compiler here -- in make's own
# namespace it is the built-in default, cc -- while $(CFLAGS) and $(LDFLAGS) are the
# target's, so the host compile of gen was handed the target sysroot and its -m flags.
CONFIGURE_ARGS += BUILD_CC="$(call native,gcc)"
CONFIGURE_ARGS += BUILD_CFLAGS=""
CONFIGURE_ARGS += BUILD_CPPFLAGS=""
CONFIGURE_ARGS += BUILD_LDFLAGS=""
CONFIGURE_ARGS += BUILD_LIBS=""

include ../../mk/spksrc.cross-cc.mk
