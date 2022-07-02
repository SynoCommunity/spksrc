PKG_NAME = libkiwix
PKG_VERS = 11.0.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/kiwix/libkiwix/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# compiler too old for cross/libzim
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

DEPENDS = cross/libicu cross/libzim cross/pugixml cross/curl cross/libmicrohttpd cross/mustache

HOMEPAGE = https://www.kiwix.org/
COMMENT  = Common code base for all Kiwix ports.
LICENSE  = GPLv3

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-meson.mk
