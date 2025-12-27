PKG_NAME = libunibreak
PKG_VERS = 6.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)_$(subst .,_,$(PKG_VERS)).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/adah1972/libunibreak/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_NAME)_$(subst .,_,$(PKG_VERS))

DEPENDS =

HOMEPAGE = https://github.com/adah1972/libunibreak
COMMENT  = Implementation of the line breaking and word/grapheme breaking algorithms as described in Unicode Standard Annex 14 (UAX #14) and Unicode Standard Annex 29 (UAX #29).
LICENSE  = Zlib license

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = libuniberak_pre_configure

CONFIGURE_ARGS = --disable-static
ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk

.PHONY: libuniberak_pre_configure
libuniberak_pre_configure:
	@$(RUN) NOCONFIGURE=1 ./autogen.sh
