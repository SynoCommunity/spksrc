PKG_NAME = tt-rss
PKG_GIT_HASH = 5cbcc14224e52861512242c39aeeb961a82dadac
PKG_VERS = $(shell echo $(PKG_GIT_HASH) | cut -c1-8)
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_DIST_SITE = https://github.com/tt-rss/tt-rss.git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS =

HOMEPAGE = https://tt-rss.org/
COMMENT  = Tiny Tiny RSS is an open source web-based news feed (RSS/Atom) reader and aggregator, designed to allow you to read news from any location, while feeling as close to a real desktop application as possible.
LICENSE  = GPL

INSTALL_TARGET = tt-rss_install

include ../../mk/spksrc.install-resources.mk

.PHONY: tt-rss_install
tt-rss_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/tt-rss
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
	echo "git-$(PKG_VERS)" > $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)/version_static.txt
