PKG_NAME = libgeos
PKG_VERS = 3.12.3
PKG_EXT = tar.bz2
PKG_DIST_NAME = geos-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.osgeo.org/geos
PKG_DIR = geos-$(PKG_VERS)

HOMEPAGE = https://libgeos.org/
COMMENT = GEOS (Geometry Engine - Open Source) is a C/C++ library for computational geometry
LICENSE = LGPL-2.1

# Disable tests to avoid cross-compilation issues and speed up build
CMAKE_ARGS = -DBUILD_TESTING=OFF

# GEOS uses CMake
include ../../mk/spksrc.cross-cmake.mk
