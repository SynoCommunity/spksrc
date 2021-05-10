PKG_NAME = libmatroska
PKG_VERS = 1.5.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://dl.matroska.org/downloads/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libebml

HOMEPAGE = https://matroska.org/
COMMENT  = libmatroska is a C++ libary to parse Matroska files (.mkv and .mka).
LICENSE  = LGPL

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cmake.mk
