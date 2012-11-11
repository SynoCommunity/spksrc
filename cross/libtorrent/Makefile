PKG_NAME = libtorrent
PKG_VERS = 0.16.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-rasterbar-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://libtorrent.googlecode.com/files
PKG_DIR = $(PKG_NAME)-rasterbar-$(PKG_VERS)

DEPENDS = cross/boost

HOMEPAGE = http://www.rasterbar.com/products/libtorrent/
COMMENT  = libtorrent is a feature complete C++ bittorrent implementation focusing on efficiency and scalability. It runs on embedded devices as well as desktops.
LICENSE  = BSD

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
