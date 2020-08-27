PKG_NAME = deluge
PKG_VERS = 2.0.4-str0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Strangelovian/deluge/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libtorrent

HOMEPAGE = https://deluge-torrent.org/
# cross/boost: archs lacking C++11 compiler, 88f6281(arm5) and ppc archs except QorIQ
# libtorrent: qoriq(ppc) evansport(x86) lack some recent linux includes network definitions (if_link.h IFLA_CARRIER IFLA_PROMISCUITY)
UNSUPPORTED_ARCHS = hi3535 $(ARM5_ARCHES) $(PPC_ARCHES) $(x86_ARCHES)

HOMEPAGE = http://deluge-torrent.org/
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
