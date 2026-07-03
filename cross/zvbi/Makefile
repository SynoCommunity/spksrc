PKG_NAME = zvbi
PKG_VERS = 0.2.44
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/zapping-vbi/zvbi/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpng

HOMEPAGE = https://zapping.sf.net/ZVBI
COMMENT  = Vertical Blanking Interval capture and decoding library
LICENSE  = GPL

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = zvbi_pre_configure

PATCHES_LEVEL = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: zvbi_pre_configure
zvbi_pre_configure:
	$(RUN) autoreconf -ivf
