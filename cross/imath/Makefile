PKG_NAME = imath
PKG_VERS = 3.2.3
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/AcademySoftwareFoundation/Imath/archive/
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = Imath-$(PKG_VERS)

DEPENDS =

# CMake's cxx_std_14 compile feature: gcc 4.7.3 has none, 4.8.3 builds.
MIN_GCC_VERSION = 4.8

HOMEPAGE = https://github.com/AcademySoftwareFoundation/Imath
COMMENT  = C++ and python library of 2D and 3D vector, matrix, and math operations for computer graphics.
LICENSE  = BSD-3-Clause

CONFIGURE_ARGS += -DBUILD_TESTING=OFF
CONFIGURE_ARGS += -DIMATH_INSTALL_PKG_CONFIG=ON

include ../../mk/spksrc.cross-cmake.mk
