PKG_NAME = dumptorrent
PKG_VERS = 1.3
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/TheGoblinHero/dumptorrent/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
DEPENDS =

HOMEPAGE = https://github.com/TheGoblinHero/dumptorrent
COMMENT  = DumpTorrent is a non-interactive text mode program which displays BitTorrent .torrent file information, including size, file names, announce[-list], comment, publisher and info_hash. It can also query (scrape) tracker for current downloader count.

CONFIGURE_TARGET = nop
INSTALL_TARGET = install-binaries

include ../../mk/spksrc.cross-cc.mk

install-binaries: $(STAGING_INSTALL_PREFIX)/bin/dumptorrent $(STAGING_INSTALL_PREFIX)/bin/scrapec

$(STAGING_INSTALL_PREFIX)/bin/dumptorrent:
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/dumptorrent $@

$(STAGING_INSTALL_PREFIX)/bin/scrapec: 
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/scrapec $@
