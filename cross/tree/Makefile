PKG_NAME = tree
PKG_VERS = 2.0.2
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://mama.indstate.edu/users/ice/tree/src
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://mama.indstate.edu/users/ice/tree/
COMMENT  = Tree is a recursive directory listing command that produces a depth indented listing of files, which is colorized ala dircolors if the LS_COLORS environment variable is set and output is to tty.
LICENSE  = GPLv2

CONFIGURE_TARGET = nop

ADDITIONAL_CFLAGS = -std=gnu99 -O3 -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64

INSTALL_MAKE_OPTIONS = install PREFIX=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk
