PKG_NAME = flac
PKG_VERS = 1.3.1
PKG_EXT = tar.xz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/$(PKG_NAME)/$(PKG_NAME)-src

DEPENDS = cross/libogg

HOMEPAGE = http://flac.sourceforge.net/
COMMENT  = Free Lossless Audio Codec
LICENSE  = GPL

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --disable-static
ifeq ($(findstring $(ARCH),powerpc ppc824x ppc853x ppc854x qoriq),$(ARCH))
  CONFIGURE_ARGS += --disable-altivec
endif

include ../../mk/spksrc.cross-cc.mk

