PKG_NAME = texinfo
PKG_VERS = 6.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnu.org/gnu/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncurses

HOMEPAGE = http://www.gnu.org/s/texinfo/
COMMENT  = Texinfo is the official documentation format of the GNU project
LICENSE  = GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-nls

include ../../mk/spksrc.cross-cc.mk
