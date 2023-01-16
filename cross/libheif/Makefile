PKG_NAME = libheif
PKG_VERS = 1.12.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/strukturag/libheif/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libjpeg cross/libpng cross/libde265 cross/x265

# ARMv5 and OLD_PPC_ARCHS fail on cross/libde265
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

HOMEPAGE = http://www.libheif.org
COMMENT  = libheif is a ISO/IEC 23008-12:2017 HEIF file format decoder and encoder.
LICENSE  = LGPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-examples --disable-go --disable-static
ADDITIONAL_CXXFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
