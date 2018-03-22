PKG_NAME = tree
PKG_VERS = 1.7.0
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://mama.indstate.edu/users/ice/tree/src/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = http://mama.indstate.edu/users/ice/tree/
COMMENT  = Tree is a recursive directory listing command that produces a depth indented listing of files, which is colorized ala dircolors if the LS_COLORS environment variable is set and output is to tty. Tree has been ported and reported to work under the following operating systems: Linux, FreeBSD, OS X, Solaris, HP/UX, Cygwin, HP Nonstop and OS/2.
# LICENSE  = 

ADDITIONAL_CFLAGS = -fomit-frame-pointer

GNU_CONFIGURE = 1
CONFIGURE_TARGET = none
#INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
#	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
	$(RUN) $(MAKE) install DESTDIR=$(STAGING_INSTALL_PREFIX)
