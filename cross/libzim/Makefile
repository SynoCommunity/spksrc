PKG_NAME = libzim
PKG_VERS = 6.3.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/openzim/libzim/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/xz cross/zstd

HOMEPAGE = https://www.kiwix.org/
COMMENT  = Reference implementation of the ZIM specification 
LICENSE  = GPLv2

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-meson.mk
