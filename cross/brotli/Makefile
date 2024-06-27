PKG_NAME = brotli
PKG_VERS = 1.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/google/brotli/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/google/brotli/
COMMENT  = Brotli compression format.
LICENSE  = MIT

CMAKE_ARGS += -DBROTLI_DISABLE_TESTS=true

include ../../mk/spksrc.cross-cmake.mk
