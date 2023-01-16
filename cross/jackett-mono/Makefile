PKG_NAME = Jackett
PKG_VERS = 0.20.1171
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME).Binaries.Mono.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Jackett/Jackett/releases/download/v$(PKG_VERS)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = jackett

DEPENDS =

HOMEPAGE = https://github.com/Jackett/Jackett
COMMENT  = Jackett works as a proxy server: it translates queries from apps into tracker-site-specific http queries, parses the html response, then sends results back to the requesting software. Jackett is a single repository of maintained indexer scraping & translation logic - removing the burden from other apps.
LICENSE  = GNU GPL v2

INSTALL_TARGET = jackett_install

include ../../mk/spksrc.install-resources.mk

jackett_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share
	tar -cf - -C $(WORK_DIR)/$(PKG_NAME) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share
