PKG_NAME = zvbi
PKG_VERS = 0.2.46
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

# configure falls back on its own -O2 only when CFLAGS is unset, and spksrc
# always sets it: without a level of its own, the library is built -O0.
ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk

.PHONY: zvbi_pre_configure
zvbi_pre_configure:
	$(RUN) autoreconf -ivf
