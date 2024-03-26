PKG_NAME = gdal
PKG_VERS = 3.8.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/OSGeo/gdal/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libproj

HOMEPAGE = https://gdal.org/

COMMENT = GDAL is an open source MIT licensed translator library for raster and vector geospatial data formats 
LICENSE = LGPL

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cmake.mk
