PKG_NAME = mg
PKG_VERS = 3.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/troglobit/mg/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncurses

HOMEPAGE = https://man.troglobit.com/man1/mg.1.html
COMMENT  = Micro (GNU) Emacs-like text editor.
LICENSE  = UNLICENSE

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
