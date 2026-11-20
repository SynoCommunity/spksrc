PKG_NAME = twolame
PKG_VERS = 0.4.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.sourceforge.net/twolame
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.twolame.org/
COMMENT  = Optimised MPEG Audio Layer 2 (MP2) encoder
LICENSE  = LGPL

GNU_CONFIGURE = 1

# configure falls back on its own -O2 only when CFLAGS is unset, and spksrc
# always sets it: without a level of its own, the library is built -O0.
ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk
