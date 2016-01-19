PKG_NAME = nano
PKG_VERS = 2.5.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.gnu.org/pub/gnu/nano
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncurses

HOMEPAGE = http://www.nano-editor.org
COMMENT  = nano is a text editor for Unix-like computing systems or operating environments using a command line interface.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
