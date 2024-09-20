PKG_NAME = libtheora
PKG_VERS = 1.1.1
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.xiph.org/releases/theora
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libogg cross/libvorbis

HOMEPAGE = https://www.theora.org/
COMMENT  = Theora is a free and open video compression format from the Xiph.org Foundation.
LICENSE  = BSD-Style

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --disable-examples
CONFIGURE_ARGS += --disable-spec

ifeq ($(strip $(GCC_DEBUG_INFO)),1)
  COMPILE_MAKE_OPTIONS = debug
endif

include ../../mk/spksrc.cross-cc.mk
