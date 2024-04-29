PKG_NAME = libarcus
PKG_VERS = 2.7.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Ultimaker/libArcus/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = libArcus-$(PKG_VERS)

DEPENDS = cross/protobuf

HOMEPAGE = https://ultimaker.com/software/ultimaker-cura
COMMENT = Communication library between internal components for Ultimaker software.
LICENSE = LGPLv3

GNU_CONFIGURE = 1

CMAKE_ARGS += -DBUILD_PYTHON=OFF
CMAKE_ARGS += -DBUILD_EXAMPLES=OFF

include ../../mk/spksrc.cross-cmake.mk
