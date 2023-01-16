PKG_NAME = attr
# newer versions are missing include/xattr.h (required by cross/dar to enable extended attr support)
PKG_VERS = 2.4.47
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).src.$(PKG_EXT)
PKG_DIST_SITE = https://download.savannah.gnu.org/releases/attr
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://savannah.nongnu.org/projects/attr/
COMMENT  = Commands for Manipulating Filesystem Extended Attributes.
LICENSE  = GPLv2+

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-static=no

INSTALL_MAKE_OPTIONS = install-lib install-dev DIST_ROOT=$(INSTALL_DIR)

include ../../mk/spksrc.cross-cc.mk
