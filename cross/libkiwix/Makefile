PKG_NAME = libkiwix
PKG_VERS = 14.2.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/kiwix/libkiwix/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# compiler for cross/libzim
MIN_GCC_VERSION = 7.5

DEPENDS = cross/libzim cross/pugixml cross/curl cross/libmicrohttpd cross/mustache

HOMEPAGE = https://www.kiwix.org/
COMMENT  = Common code base for all Kiwix ports.
LICENSE  = GPLv3

CONFIGURE_ARGS = -Dwerror=false

# Using patches/001-Fix-build-with-ICU-77.patch
# instead of passing additional LD flags
#ADDITIONAL_LDFLAGS = -licui18n -licuuc -licudata

# avoid unreferenced symbols of std::filesystem::*
ADDITIONAL_LDFLAGS = -lstdc++fs

include ../../mk/spksrc.cross-meson.mk
