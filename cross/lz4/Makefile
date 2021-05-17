PKG_NAME = lz4
PKG_VERS = 1.9.3
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/lz4/lz4/archive/
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)/build/cmake

DEPENDS =

HOMEPAGE = https://github.com/lz4/lz4
COMMENT  = LZ4 is lossless compression algorithm, providing compression speed at 400 MB/s per core, scalable with multi-cores CPU.
LICENSE  = BSD

include ../../mk/spksrc.cross-cmake.mk
