PKG_NAME = xz
PKG_VERS = 5.8.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/tukaani-project/xz/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://tukaani.org
COMMENT  = Free general-purpose data compression software with high compression ratio.
LICENSE  = various

CMAKE_ARGS  = -DBUILD_SHARED_LIBS=ON
CMAKE_ARGS += -DBUILD_STATIC_LIBS=OFF
CMAKE_ARGS += -DBUILD_TESTING=OFF
CMAKE_ARGS += -DXZ_DOC=OFF
CMAKE_ARGS += -DXZ_TOOL_SCRIPTS=OFF

include ../../mk/spksrc.cross-cmake.mk
