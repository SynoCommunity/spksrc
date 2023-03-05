PKG_NAME = libunistring
PKG_VERS = 1.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/libunistring
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.gnu.org/software/libunistring/
COMMENT  = This library provides functions for manipulating Unicode strings and for manipulating C strings according to the Unicode standard.
LICENSE  = LGPLv3

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --disable-static
ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk
