PKG_NAME = jasper
PKG_VERS = 3.0.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/jasper-software/jasper/releases/download/version-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.ece.uvic.ca/~mdadams/jasper
COMMENT  = JasPer includes a software-based implementation of the codec specified in the JPEG-2000 Part-1 standard (i.e., ISO/IEC 15444-1).
LICENSE  = MIT

CMAKE_ARGS += -DJAS_ENABLE_PROGRAMS=OFF
# STDC version must be provided for cross compilation
# C99 = 199901L
# C11 = 201112L
CMAKE_ARGS += -DJAS_STDC_VERSION=199901L
CMAKE_ARGS += -DCMAKE_C_FLAGS_RELEASE="-O"

PRE_CONFIGURE_TARGET = jasper_pre_configure

include ../../mk/spksrc.cross-cmake.mk

.PHONY: jasper_pre_configure
# avoid error as build wants to create $(CMAKE_BUILD_DIR)/build folder
jasper_pre_configure:
	mv $(CMAKE_BUILD_DIR)/build $(CMAKE_BUILD_DIR)/build.sh
