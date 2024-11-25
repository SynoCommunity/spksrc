PKG_NAME = cJSON
PKG_VERS = 1.7.18
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/DaveGamble/cJSON/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/DaveGamble/cJSON
COMMENT  = Ultralightweight JSON parser in ANSI C.
LICENSE  = MIT

CMAKE_ARGS += -DENABLE_CJSON_TEST=OFF

include ../../mk/spksrc.cross-cmake.mk
