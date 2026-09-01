PKG_NAME = attr
PKG_VERS = 2.6.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.savannah.gnu.org/releases/attr
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

MIN_GCC_VERSION = 4.4

HOMEPAGE = https://savannah.nongnu.org/projects/attr/
COMMENT  = Commands for Manipulating Filesystem Extended Attributes.
LICENSE  = GPLv2+

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static

include ../../mk/spksrc.cross-cc.mk
