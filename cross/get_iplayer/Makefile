PKG_NAME = get_iplayer
PKG_VERS = 2.94
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.infradead.org/pub/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = http://www.infradead.org/get_iplayer/html/get_iplayer.html
COMMENT  = get_iplayer allows you to search, index and record/stream BBC iPlayer radio and TV.
LICENSE  = GPLv3+

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY:
myInstall:
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin/
	@$(RUN) install -m 755 get_iplayer $(STAGING_INSTALL_PREFIX)/bin

