PKG_NAME = tree
PKG_VERS = 1.8.0
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://mama.indstate.edu/users/ice/tree/src
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://mama.indstate.edu/users/ice/tree/
COMMENT  = Tree is a recursive directory listing command that produces a depth indented listing of files, which is colorized ala dircolors if the LS_COLORS environment variable is set and output is to tty.
LICENSE  = GPLv2

ADDITIONAL_CFLAGS = -fomit-frame-pointer

CONFIGURE_TARGET = nop
INSTALL_TARGET = tree_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: tree_install
tree_install:
	$(RUN) $(MAKE) install prefix=$(STAGING_INSTALL_PREFIX)
