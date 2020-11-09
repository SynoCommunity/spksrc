PKG_NAME = deluge
PKG_VERS = 2.0.3
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://download.deluge-torrent.org/source/2.0
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libtorrent

HOMEPAGE = https://deluge-torrent.org/
COMMENT  = Deluge is a lightweight, Free Software, cross-platform BitTorrent client.
LICENSE  = MIT License

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = deluge_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: deluge_install
deluge_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/deluge
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/deluge
