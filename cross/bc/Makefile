PKG_NAME = bc
PKG_VERS = 1.06
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnu.org/gnu/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.gnu.org/software/bc/
COMMENT  = bc is an arbitrary precision numeric processing language
LICENSE  = GPLv3

ENV += CFLAGS=
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-nls

include ../../mk/spksrc.cross-cc.mk
