PKG_NAME = openjpeg
PKG_VERS = 2.5.4
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/uclouvain/openjpeg/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libtiff cross/libjpeg cross/libpng cross/lcms2

HOMEPAGE = https://github.com/uclouvain/openjpeg#readme
COMMENT  = OpenJPEG is an open-source JPEG 2000 codec written in C language. 
LICENSE  = BSD 2-clause simplified

CMAKE_USE_NINJA = 1
CONFIGURE_ARGS += -Wno-dev
CONFIGURE_ARGS += -DBUILD_STATIC_LIBS=OFF
CONFIGURE_ARGS += -DOPENJP2_COMPILE_OPTIONS="-O"
# deactivate build of tools (we use the library only)
CONFIGURE_ARGS += -DBUILD_CODEC=OFF

include ../../mk/spksrc.cross-cmake.mk
