PKG_NAME = deluge
PKG_VERS = 2.0.5
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.osuosl.org/pub/deluge/source/2.0
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://deluge-torrent.org/
COMMENT  = Deluge is a lightweight, Free Software, cross-platform BitTorrent client.
LICENSE  = MIT

INSTALL_TARGET = deluge_install

include ../../mk/spksrc.install-resources.mk

.PHONY: deluge_install
deluge_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/deluge
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/deluge
