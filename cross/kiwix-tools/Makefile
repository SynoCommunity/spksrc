PKG_NAME = kiwix-tools
PKG_VERS = 3.8.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/kiwix/kiwix-tools/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# compiler for cross/libzim
MIN_GCC_VERSION = 7.5

DEPENDS = cross/libkiwix cross/docopt

HOMEPAGE = https://www.kiwix.org/
COMMENT = Command line Kiwix tools: kiwix-serve, kiwix-manage, ...
LICENSE = GPLv3

include ../../mk/spksrc.cross-meson.mk
