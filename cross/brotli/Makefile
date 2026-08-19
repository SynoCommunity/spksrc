PKG_NAME = brotli
PKG_VERS = 1.2.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/google/brotli/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/google/brotli/
COMMENT  = Brotli compression format.
LICENSE  = MIT

CONFIGURE_ARGS = -DBROTLI_DISABLE_TESTS=true

include ../../mk/spksrc.common.mk
ifeq ($(call version_lt, $(TC_GCC), 4.7),1)
ADDITIONAL_CFLAGS = -std=c99
else
ADDITIONAL_CFLAGS = -std=c11
endif

include ../../mk/spksrc.cross-cmake.mk
