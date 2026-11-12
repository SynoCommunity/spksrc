PKG_NAME = libebml
PKG_VERS = 1.4.4
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://dl.matroska.org/downloads/libebml
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# C++14 generic lambdas (EbmlMaster.cpp): gcc 4.9.
MIN_GCC_VERSION = 4.9

HOMEPAGE = http://matroska.org
COMMENT  = libebml is a C++ libary to parse EBML files.
LICENSE  = LGPL

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cmake.mk
