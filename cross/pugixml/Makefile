PKG_NAME = pugixml
PKG_VERS = 1.12.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/zeux/pugixml/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))

DEPENDS =

HOMEPAGE = https://pugixml.org/
COMMENT  = Light-weight, simple and fast XML parser for C++ with XPath support.
LICENSE  = MIT

GNU_CONFIGURE = 1

CMAKE_USE_TOOLCHAIN_FILE = OFF

include ../../mk/spksrc.cross-cmake.mk
