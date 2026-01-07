PKG_NAME = geos
PKG_VERS = 3.12.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libgeos/geos/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = https://libgeos.org/

COMMENT = GEOS is a C/C++ library for computational geometry with a focus on algorithms used in geographic information systems (GIS) software. It implements the OGC Simple Features geometry model and provides all the spatial functions in that standard as well as many others. GEOS is a core dependency of PostGIS, QGIS, GDAL, Shapely and many others.
LICENSE = LGPL

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cmake.mk

