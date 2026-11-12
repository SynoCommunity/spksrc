PKG_NAME = libmatroska
PKG_VERS = 1.7.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://dl.matroska.org/downloads/libmatroska
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libebml

# C++14 generic lambdas (libebml's EbmlMaster.cpp): gcc 4.9.
MIN_GCC_VERSION = 4.9

HOMEPAGE = https://matroska.org/
COMMENT  = libmatroska is a C++ libary to parse Matroska files (.mkv and .mka).
LICENSE  = LGPL

GNU_CONFIGURE = 1

# Static by default since 1.7.2 (cmake_dependent_option, OFF).
CONFIGURE_ARGS += -DBUILD_SHARED_LIBS=ON

include ../../mk/spksrc.cross-cmake.mk
