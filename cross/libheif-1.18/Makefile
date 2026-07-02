PKG_NAME = libheif
PKG_VERS = 1.18.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/strukturag/libheif/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/libjpeg
DEPENDS += cross/libpng
DEPENDS += cross/libde265
DEPENDS += cross/x265
# libwebp for libsharpyuv:
DEPENDS += cross/libwebp
DEPENDS += cross/gdk-pixbuf

# ARMv5 and OLD_PPC_ARCHS fail on cross/libde265
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

HOMEPAGE = http://www.libheif.org
COMMENT  = libheif is a ISO/IEC 23008-12:2017 HEIF file format decoder and encoder.
LICENSE  = LGPLv3

CMAKE_ARGS += -DWITH_EXAMPLES=OFF
CMAKE_ARGS += -DBUILD_TESTING=OFF

ADDITIONAL_CXXFLAGS = -O

include ../../mk/spksrc.cross-cmake.mk
