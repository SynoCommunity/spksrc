PKG_NAME = get_iplayer

NAME = get_iplayer
PKG_DIST_SITE = git://git.infradead.org/get_iplayer.git
PKG_GIT_HASH = f495e0d
PKG_DOWNLOAD_METHOD = git

PKG_EXT = tar.gz
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

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


