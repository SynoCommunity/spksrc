PKG_NAME = proj
PKG_VERS = 9.3.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/OSGeo/PROJ/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/sqlite cross/libtiff cross/curl

HOMEPAGE = https://proj.org/

COMMENT = PROJ - Cartographic Projections and Coordinate Transformations Library 
LICENSE = LGPL

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cmake.mk
