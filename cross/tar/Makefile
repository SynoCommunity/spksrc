PKG_NAME = tar
PKG_VERS = 1.29
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnu.org/gnu/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.gnu.org/software/tar/
COMMENT  = GNU Tar provides the ability to create tar archives, as well as various other kinds of manipulation.
LICENSE  = GPLv3

GNU_CONFIGURE = 1
ENV += FORCE_UNSAFE_CONFIGURE=1
CONFIGURE_ARGS = --disable-nls

include ../../mk/spksrc.cross-cc.mk
