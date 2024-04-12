PKG_NAME = libkiwix
PKG_VERS = 13.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/kiwix/libkiwix/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# compiler too old for cross/libzim
REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k

DEPENDS = cross/libzim cross/pugixml cross/curl cross/libmicrohttpd cross/mustache

HOMEPAGE = https://www.kiwix.org/
COMMENT  = Common code base for all Kiwix ports.
LICENSE  = GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = -Dwerror=false

include ../../mk/spksrc.cross-meson.mk
