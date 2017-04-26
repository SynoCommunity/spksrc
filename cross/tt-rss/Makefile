PKG_NAME = tt-rss
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = wget
PKG_GIT_HASH = 467bc4fe03499791bb17a9485b2ea44729600c1b
PKG_GIT_TAG = 17.4
PKG_DIST_NAME = archive.tar.gz?ref=$(PKG_GIT_TAG)
PKG_DIST_SITE = https://tt-rss.org/fox/$(PKG_NAME)/repository
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_GIT_TAG)-$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_GIT_TAG)-$(PKG_GIT_HASH)

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
