PKG_NAME = libheif
PKG_VERS = 1.20.2
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

# requires the language dialect "CXX20".
REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = comcerto2k

HOMEPAGE = http://www.libheif.org
COMMENT  = libheif is a ISO/IEC 23008-12:2017 HEIF file format decoder and encoder.
LICENSE  = LGPLv3

CMAKE_ARGS += -DWITH_EXAMPLES=OFF
CMAKE_ARGS += -DBUILD_TESTING=OFF

ADDITIONAL_CXXFLAGS = -O

include ../../mk/spksrc.cross-cmake.mk
