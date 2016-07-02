PKG_NAME = nethogs
_PKG_VERS = 0.8
PKG_VERS = 0.8.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/$(PKG_NAME)/$(PKG_NAME)/$(_PKG_VERS)
PKG_DIR = $(PKG_NAME)

DEPENDS = cross/libpcap cross/ncurses

MAINTAINER = SynoCommunity
HOMEPAGE   = http://nethogs.sourceforge.net/
COMMENT    = NetHogs is a small 'net top' tool.
LICENSE    = GNU GPL 2

CONFIGURE_TARGET = nop
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

myCompile:
	$(RUN) $(MAKE) CFLAGS="$(CFLAGS) $(LDFLAGS)"
myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(STAGING_INSTALL_PREFIX)
