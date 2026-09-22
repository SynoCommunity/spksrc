PKG_NAME = libzim
PKG_VERS = 9.8.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/openzim/libzim/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zstd cross/xz cross/libicu cross/libxapian

# ERROR: C++ Compiler does not support -std=c++17
MIN_GCC_VERSION = 7.5

HOMEPAGE = https://www.kiwix.org/
COMMENT = Reference implementation of the ZIM specification.
LICENSE = GPLv2

CONFIGURE_ARGS  = -Dexamples=false
CONFIGURE_ARGS += -Dtests=false

include ../../mk/spksrc.cross-meson.mk
