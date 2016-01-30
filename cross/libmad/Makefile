PKG_NAME = libmad
PKG_VERS = 0.15.1b
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/mad/$(PKG_NAME)/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.underbit.com/products/mad/
COMMENT  = High-quality fixed-point MPEG audio decoder with 24-bit output
LICENSE  = GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static
ifeq ($(findstring $(ARCH),88f5281 88f6281 alpine armada370 armada375 armadaxp),$(ARCH))
CONFIGURE_ARGS += --enable-fpm=default
endif

include ../../mk/spksrc.cross-cc.mk

