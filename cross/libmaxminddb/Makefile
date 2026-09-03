PKG_NAME = libmaxminddb
PKG_VERS = 1.4.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/maxmind/$(PKG_NAME)/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://maxmind.github.io/libmaxminddb/
COMMENT  = C library for the MaxMind DB file format.
LICENSE  = Apache-2.0

GNU_CONFIGURE = 1

include ../../mk/spksrc.common.mk

# The bundled libtap uses MAP_ANONYMOUS, which the glibc headers shipped with the
# pre-4.8 toolchains only expose under _DEFAULT_SOURCE -- and libmaxminddb builds
# with -std=c99, which turns that off. Keyed on the compiler rather than an arch
# list so x86-5.2 and x64-5.2 (gcc 4.7.3) are covered too; they failed the same
# way on "MAP_ANONYMOUS undeclared" and were simply never built.
ifeq ($(call version_lt,$(TC_GCC),4.8),1)
ADDITIONAL_CFLAGS = -DMAP_ANONYMOUS=0x20
endif

include ../../mk/spksrc.cross-cc.mk
