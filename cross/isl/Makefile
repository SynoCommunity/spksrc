PKG_NAME = isl
PKG_VERS = 0.25
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://libisl.sourceforge.io/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/gmp

HOMEPAGE = https://libisl.sourceforge.io/
COMMENT  = isl is a library for manipulating sets and relations of integer points bounded by linear constraints.
LICENSE  = MIT

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
