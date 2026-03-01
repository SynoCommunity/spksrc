PKG_NAME = libproj
PKG_VERS = 8.2.1
PKG_EXT = tar.gz
PKG_DIST_NAME = proj-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.osgeo.org/proj
PKG_DIR = proj-$(PKG_VERS)

DEPENDS = cross/sqlite cross/libtiff cross/curl
BUILD_DEPENDS = native/sqlite

HOMEPAGE = https://proj.org/
COMMENT = PROJ is a generic coordinate transformation software
LICENSE = MIT

# PROJ uses CMake
NATIVE_SQLITE_DIR = $(realpath $(WORK_DIR)/../../../native/sqlite/work-native/install/usr/local)
CMAKE_ARGS += -DBUILD_TESTING=OFF
CMAKE_ARGS += -DENABLE_CURL=ON
CMAKE_ARGS += -DENABLE_TIFF=ON
CMAKE_ARGS += -DEXE_SQLITE3=$(NATIVE_SQLITE_DIR)/bin/sqlite3

include ../../mk/spksrc.cross-cmake.mk
