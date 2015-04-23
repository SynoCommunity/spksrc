PKG_NAME = flac
PKG_VERS = 1.3.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/flac/$(PKG_NAME)-src
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libogg

HOMEPAGE = http://flac.sourceforge.net/
COMMENT  = Free Lossless Audio Codec
LICENSE  = GPL

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --disable-thorough-tests --disable-doxygen-docs --disable-oggtest

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(PPC_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --disable-altivec
endif

