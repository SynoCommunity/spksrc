PKG_NAME = tt-rss
PKG_VERS = 67f02e2aa7
PKG_EXT = tar.gz
PKG_GIT_HASH = 67f02e2aa7b246ef7ca2b2aa4c62e2826327d219
PKG_DIST_SITE = https://git.tt-rss.org/fox/tt-rss.git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)
PKG_DOWNLOAD_METHOD = git
DEPENDS =

HOMEPAGE = http://tt-rss.org/
COMMENT  = Tiny Tiny RSS is an open source web-based news feed (RSS/Atom) reader and aggregator, designed to allow you to read news from any location, while feeling as close to a real desktop application as possible.
LICENSE  = GPL

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/tt-rss
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
