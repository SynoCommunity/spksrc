PKG_NAME = librsync
PKG_VERS = 2.3.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/librsync/$(PKG_NAME)/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/popt cross/zlib cross/bzip2

HOMEPAGE = http://librsync.sourcefrog.net
COMMENT  = remote delta-compression library.
LICENSE  = LPGL-2.1

CMAKE_ARGS += -D BZIP2_LIBRARIES=$(STAGING_INSTALL_PREFIX)/lib
CMAKE_ARGS += -D ZLIB_LIBRARY=$(STAGING_INSTALL_PREFIX)/lib
CMAKE_ARGS += -Wno-dev

include ../../mk/spksrc.cross-cmake.mk
