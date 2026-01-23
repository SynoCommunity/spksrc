PKG_NAME = libewf
PKG_VERS = 20240506
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-experimental-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libyal/libewf/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/bzip2 cross/libuuid

HOMEPAGE = https://github.com/libyal/libewf/wiki
COMMENT  = Libewf is a library to access the Expert Witness Compression Format (EWF).
LICENSE  = LGPLv3

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --enable-wide-character-type

ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk
