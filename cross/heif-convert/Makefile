PKG_NAME = heif-convert
PKG_VERS = 1.18.2
PKG_EXT = tar.gz
PKG_DIST_NAME = libheif-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/strukturag/libheif/releases/download/v$(PKG_VERS)
PKG_DIR = libheif-$(PKG_VERS)

# Build heif-convert from libheif 1.18.2 (last version with examples/).
# We build the full library + examples in one shot, but only ship the CLI tools.
HOMEPAGE = https://github.com/strukturag/libheif
COMMENT  = HEIC/HEIF to JPEG conversion tool (heif-convert from libheif 1.18.2)
LICENSE  = LGPL-3.0

DEPENDS  = cross/libde265
DEPENDS += cross/libjpeg
DEPENDS += cross/libpng
DEPENDS += cross/x265
DEPENDS += cross/libwebp

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)
REQUIRED_MIN_DSM = 7.1

CMAKE_ARGS  = -DWITH_EXAMPLES=ON
CMAKE_ARGS += -DBUILD_TESTING=OFF
CMAKE_ARGS += -DWITH_GDK_PIXBUF=OFF

ADDITIONAL_CXXFLAGS = -O

POST_INSTALL_TARGET = heif_convert_fix_symlink

include ../../mk/spksrc.cross-cmake.mk

.PHONY: heif_convert_fix_symlink
heif_convert_fix_symlink:
	@if [ -L $(STAGING_INSTALL_PREFIX)/bin/heif-convert ]; then \
	  cp --remove-destination $(STAGING_INSTALL_PREFIX)/bin/heif-dec $(STAGING_INSTALL_PREFIX)/bin/heif-convert ; \
	fi
