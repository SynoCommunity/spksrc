PKG_NAME = emacs
PKG_VERS = 26.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/gnutls cross/ncurses

HOMEPAGE = https://www.gnu.org/software/emacs/
COMMENT  = Emacs is the extensible, customizable, self-documenting real-time display editor.
LICENSE  = GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --without-x --with-gnutls --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --with-x-toolkit=no --with-xpm=no --with-jpeg=no --with-png=no --with-gif=no --with-tiff=no

include ../../mk/spksrc.cross-cc.mk
