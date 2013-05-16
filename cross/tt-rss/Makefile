PKG_NAME = tt-rss
PKG_FULL_NAME = Tiny-Tiny-RSS
PKG_VERS = 1.7.9
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/gothfox/$(PKG_FULL_NAME)/archive
PKG_DIR = $(PKG_FULL_NAME)-$(PKG_VERS)

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
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/tt-rss
