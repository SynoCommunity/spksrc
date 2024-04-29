PKG_NAME = libzim
PKG_VERS = 9.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/openzim/libzim/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/xz cross/zstd cross/libicu cross/libxapian

# ERROR: C++ Compiler does not support -std=c++17
REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k

HOMEPAGE = https://www.kiwix.org/
COMMENT  = Reference implementation of the ZIM specification.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = -Dexamples=false
CONFIGURE_ARGS += -Ddoc=false
CONFIGURE_ARGS += -Dtest_data_dir=none

include ../../mk/spksrc.cross-meson.mk
