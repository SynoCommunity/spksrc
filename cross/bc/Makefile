PKG_NAME = bc
PKG_VERS = 1.08.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
# original dist site is https://ftp.gnu.org/gnu/bc
# but we are encouraged to use a mirror like this:
PKG_DIST_SITE = https://www.artfiles.org/gnu.org/bc
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.gnu.org/software/bc/
COMMENT  = bc is an arbitrary precision numeric processing language.
LICENSE  = GPLv3

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
