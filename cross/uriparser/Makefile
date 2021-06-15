PKG_NAME = uriparser
PKG_VERS = 0.9.5
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/$(PKG_NAME)/Sources/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = http://sourceforge.net/projects/uriparser
COMMENT  = Strictly RFC 3986 compliant URI parsing and handling library 
LICENSE  = New BSD license

CMAKE_ARGS  = -DCMAKE_BUILD_TYPE=Release
CMAKE_ARGS += -DURIPARSER_BUILD_DOCS=OFF
# Requires Gtest
CMAKE_ARGS += -DURIPARSER_BUILD_TESTS=OFF

include ../../mk/spksrc.cross-cmake.mk
