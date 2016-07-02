PKG_NAME = findutils
PKG_VERS = 4.6.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnu.org/gnu/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.gnu.org/s/findutils/
COMMENT  = The GNU Find Utilities are the basic directory searching utilities of the GNU operating system.
LICENSE  = GPLv3

GNU_CONFIGURE = 1
ENV += FORCE_UNSAFE_CONFIGURE=1
CONFIGURE_ARGS = --disable-nls

include ../../mk/spksrc.cross-cc.mk
