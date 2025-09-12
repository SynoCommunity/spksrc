PKG_NAME = jasper
PKG_VERS = 4.2.8
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

include ../../mk/spksrc.cross-cmake.mk

# Avoid build dir within source:
# The useof an in-source build is not officially supported and is 
# therefore disallowed by default. 
CMAKE_BUILD_DIR = $(CMAKE_BASE_DIR)/../jasper.build
CMAKE_ARGS += -B$(CMAKE_BUILD_DIR)
