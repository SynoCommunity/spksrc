PKG_NAME = stockfish-webgui
PKG_VERS = 0.0.1
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = e474343
PKG_DIST_SITE = https://github.com/antiproton/Web-GUI-for-stockfish-chess.git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

HOMEPAGE = https://genialschach.de/
COMMENT  = Web GUI for Stockfish Chess by Dr. R. Urban.
LICENSE  = MIT

INSTALL_TARGET = stockfish-webgui_install

include ../../mk/spksrc.install-resources.mk


.PHONY: stockfish-webgui_install
stockfish-webgui_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/webgui
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/webgui
