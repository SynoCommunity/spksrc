PKG_NAME = tt-rss
PKG_VERS = c30b24d09f
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = c30b24d09f4096e612965af658540595262f6848
PKG_DIST_SITE = https://git.tt-rss.org/fox/tt-rss.git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS =

HOMEPAGE = https://tt-rss.org/
COMMENT  = Tiny Tiny RSS is an open source web-based news feed (RSS/Atom) reader and aggregator, designed to allow you to read news from any location, while feeling as close to a real desktop application as possible.
LICENSE  = GPL

INSTALL_TARGET = tt-rss_install

PATCHES_LEVEL = 1

include ../../mk/spksrc.install-resources.mk

.PHONY: tt-rss_install
tt-rss_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/tt-rss
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
