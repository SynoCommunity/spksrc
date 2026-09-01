PKG_NAME = libproj
PKG_VERS = 9.8.1
PKG_EXT = tar.gz
PKG_DIST_NAME = proj-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.osgeo.org/proj
PKG_DIR = proj-$(PKG_VERS)

BUILD_DEPENDS = native/sqlite
DEPENDS = cross/sqlite
DEPENDS += cross/libtiff
DEPENDS += cross/curl

# CXX17 required
MIN_GCC_VERSION = 8

HOMEPAGE = https://proj.org/
COMMENT = PROJ is a Cartographic Projections and Coordinate Transformations Library.
LICENSE = MIT

# PROJ uses CMake
NATIVE_SQLITE_DIR = $(realpath $(WORK_DIR)/../../../native/sqlite/work-native/install/usr/local)
CONFIGURE_ARGS += -DBUILD_TESTING=OFF
CONFIGURE_ARGS += -DENABLE_CURL=ON
CONFIGURE_ARGS += -DENABLE_TIFF=ON
CONFIGURE_ARGS += -DEXE_SQLITE3=$(NATIVE_SQLITE_DIR)/bin/sqlite3

include ../../mk/spksrc.cross-cmake.mk
