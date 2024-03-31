PKG_NAME = attr
PKG_VERS = 2.5.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.savannah.gnu.org/releases/attr
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://savannah.nongnu.org/projects/attr/
COMMENT  = Commands for Manipulating Filesystem Extended Attributes.
LICENSE  = GPLv2+

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static

include ../../mk/spksrc.cross-cc.mk
