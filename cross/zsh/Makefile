PKG_NAME = zsh
PKG_VERS = 5.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.zsh.org/pub
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw

HOMEPAGE = http://www.zsh.org/
COMMENT  = Zsh is a shell designed for interactive use, although it is also a powerful scripting language.
LICENSE  = Custom

GNU_CONFIGURE = 1

INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	umask 022; $(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
