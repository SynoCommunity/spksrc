PKG_NAME = nzbget
PKG_VERS = 16.4
PKG_EXT = tar.gz
PKG_DIST_SITE = https://github.com/$(PKG_NAME)/$(PKG_NAME)/releases/download/v$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-src.$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libxml2 cross/ncurses cross/openssl

HOMEPAGE = http://nzbget.net
COMMENT  = NZBGet is a command-line based binary newsgrabber for nzb files, written in C++. It supports client/server mode, automatic par-check/-repair and web-interface. NZBGet requires low system resources.
LICENSE  = GPLv2

CONFIGURE_ARGS = LIBPREF=$(INSTALL_DIR)$(INSTALL_PREFIX)
GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
