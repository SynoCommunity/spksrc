PKG_NAME = nzbget-testing
PKG_VERS = 16.0
PKG_REV = 1439
PKG_EXT = tar.gz
PKG_DIST_SITE = https://github.com/nzbget/nzbget/releases/download/v$(PKG_VERS)-r$(PKG_REV)
PKG_DIST_FILE = nzbget-$(PKG_VERS)-testing-r$(PKG_REV)-dist.$(PKG_EXT)
PKG_DIR = nzbget-$(PKG_VERS)-testing

DEPENDS = cross/libxml2 cross/ncurses cross/openssl

HOMEPAGE = http://nzbget.net/
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
