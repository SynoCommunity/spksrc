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

# define missing MAP_ANONYMOUS for older gcc (for test functions in libtap only)
ifneq ($(findstring $(ARCH), 88f6281 ppc853x),)
ADDITIONAL_CFLAGS = -DMAP_ANONYMOUS=0x20
endif


include ../../mk/spksrc.cross-cc.mk
