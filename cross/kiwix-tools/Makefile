PKG_NAME = kiwix-tools
PKG_VERS = 3.3.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/kiwix/kiwix-tools/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libkiwix

HOMEPAGE = https://www.kiwix.org/
COMMENT  = Command line Kiwix tools: kiwix-serve, kiwix-manage, ...
LICENSE  = GPLv3

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-meson.mk
