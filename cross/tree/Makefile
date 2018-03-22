PKG_NAME = tree
PKG_VERS = 1.7.0
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://mama.indstate.edu/users/ice/tree/src/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

UNSUPPORTED_ARCHS = alpine armada370 armada375 armadaxp comcerto2k monaco rtd1296

HOMEPAGE = http://mama.indstate.edu/users/ice/tree/
COMMENT  = Tree is a recursive directory listing command that produces a depth indented listing of files, which is colorized ala dircolors if the LS_COLORS environment variable is set and output is to tty. Tree has been ported and reported to work under the following operating systems: Linux, FreeBSD, OS X, Solaris, HP/UX, Cygwin, HP Nonstop and OS/2.
# LICENSE  = 

ADDITIONAL_CFLAGS = -fomit-frame-pointer

GNU_CONFIGURE = 1
CONFIGURE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) mkdir -p $(STAGING_INSTALL_PREFIX)/bin
	$(RUN) cp $(WORK_DIR)/$(PKG_DIR)/tree $(STAGING_INSTALL_PREFIX)/bin/tree
#	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
#	$(RUN) $(MAKE) install DESTDIR=$(STAGING_INSTALL_PREFIX)
#	$(RUN) $(MAKE) install PREFIX=$(STAGING_INSTALL_PREFIX)
