PKG_NAME = libmad
PKG_VERS = 0.16.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://codeberg.org/tenacityteam/libmad/releases/download/$(PKG_VERS)
PKG_DIR = mad-$(PKG_VERS)-source

DEPENDS =

# mad.h's deprecated("message") attribute: gcc 4.5.
MIN_GCC_VERSION = 4.5

HOMEPAGE = https://codeberg.org/tenacityteam/libmad
COMMENT  = High-quality fixed-point MPEG audio decoder with 24-bit output.
LICENSE  = GPLv2

CONFIGURE_ARGS  = -DBUILD_SHARED_LIBS=ON
CONFIGURE_ARGS += -DEXAMPLE=OFF

include ../../mk/spksrc.cross-cmake.mk
