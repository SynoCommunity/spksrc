PKG_NAME = zsh
PKG_VERS = 5.7.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.zsh.org/pub
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw

HOMEPAGE = http://www.zsh.org/
COMMENT  = Zsh is a shell designed for interactive use, although it is also a powerful scripting language.
LICENSE  = Custom

GNU_CONFIGURE = 1

ifdef ZSH_STATIC_MODULES
$(info Building zsh with statically linked modules.)
POST_CONFIGURE_TARGET = link-zsh-modules
else
$(info Building zsh with dynamically linked modules.)
endif

INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	umask 022; $(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)

.PHONY: link-zsh-modules
link-zsh-modules:
	$(RUN) sed -i 's/link=no/link=static/' config.modules
	# gdbm is not available, so don't try to compile it.
	$(RUN) sed -i 's|\(name=zsh/db/gdbm.*\)link=static|\1link=no|' config.modules
