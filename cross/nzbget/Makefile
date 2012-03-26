PKG_NAME = nzbget
PKG_VERS = 0.7.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/$(PKG_NAME)/$(PKG_NAME)-stable/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libxml2 cross/ncurses cross/libsigc++ cross/libpar2 cross/openssl

HOMEPAGE = http://nzbget.sourceforge.net/
COMMENT  = NZBGet is a command-line based binary newsgrabber for nzb files, written in C++. It supports client/server mode, automatic par-check/-repair and web-interface. NZBGet requires low system resources.
LICENSE  = 

CONFIGURE_ARGS = LIBPREF=$(INSTALL_DIR)$(INSTALL_PREFIX)
GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

