PKG_NAME = libzim
PKG_VERS = 7.2.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/openzim/libzim/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# version 7.x needs libxapian
DEPENDS = cross/xz cross/zstd cross/libicu cross/libxapian

# compiler too old *** A compiler with support for C++11 language features is required.
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

HOMEPAGE = https://www.kiwix.org/
COMMENT  = Reference implementation of the ZIM specification.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

ADDITIONAL_CXXFLAGS = -fpermissive

include ../../mk/spksrc.cross-meson.mk
