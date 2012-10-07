PKG_NAME = nzbget
PKG_VERS = 9.0
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = svn
PKG_SVN_REV = 477
PKG_DIST_NAME = trunk
PKG_DIST_SITE = https://nzbget.svn.sourceforge.net/svnroot/nzbget
PKG_DIST_FILE = $(PKG_NAME)-r$(PKG_SVN_REV).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-r*

DEPENDS = cross/libxml2 cross/ncurses cross/libsigc++ cross/libpar2 cross/openssl

HOMEPAGE = http://nzbget.sourceforge.net/
COMMENT  = NZBGet is a command-line based binary newsgrabber for nzb files, written in C++. It supports client/server mode, automatic par-check/-repair and web-interface. NZBGet requires low system resources.
LICENSE  = 

PRE_CONFIGURE_TARGET = myPreConfigure
CONFIGURE_ARGS = LIBPREF=$(INSTALL_DIR)$(INSTALL_PREFIX)
GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) touch configure
	$(RUN) touch Makefile.in
