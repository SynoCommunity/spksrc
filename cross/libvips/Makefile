PKG_NAME = libvips
PKG_VERS = 8.17.3
PKG_EXT = tar.xz
PKG_DIST_NAME = vips-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libvips/libvips/releases/download/v$(PKG_VERS)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = vips-$(PKG_VERS)

DEPENDS  = cross/glib
DEPENDS += cross/libexpat
DEPENDS += cross/libxml2
DEPENDS += cross/libexif
DEPENDS += cross/libjpeg
DEPENDS += cross/libpng
DEPENDS += cross/libtiff
DEPENDS += cross/libwebp
DEPENDS += cross/lcms2
DEPENDS += cross/freetype
DEPENDS += cross/fontconfig
DEPENDS += cross/harfbuzz
DEPENDS += cross/fribidi
DEPENDS += cross/pango
DEPENDS += cross/cairo
DEPENDS += cross/librsvg
DEPENDS += cross/libarchive
DEPENDS += cross/libimagequant
DEPENDS += cross/cgif
DEPENDS += cross/libheif
DEPENDS += cross/libde265
DEPENDS += cross/x265
DEPENDS += cross/libaom-latest
DEPENDS += cross/highway

HOMEPAGE = https://www.libvips.org
COMMENT  = libvips is a fast image processing library with low memory needs.
LICENSE  = LGPLv2

CONFIGURE_ARGS  = -Ddeprecated=false
CONFIGURE_ARGS += -Dexamples=false
CONFIGURE_ARGS += -Dintrospection=disabled
CONFIGURE_ARGS += -Dmodules=disabled
CONFIGURE_ARGS += -Dheif=enabled
CONFIGURE_ARGS += -Dheif-module=disabled
CONFIGURE_ARGS += -Dcplusplus=true

POST_INSTALL_TARGET = libvips_post_install

include ../../mk/spksrc.cross-meson.mk

.PHONY: libvips_post_install
libvips_post_install:
	@cd $(STAGING_INSTALL_PREFIX)/lib && \
	  patchelf --set-soname libvips-cpp.so.8.17.3 libvips-cpp.so.42.19.3 && \
	  ln -sf libvips-cpp.so.42.19.3 libvips-cpp.so.8.17.3
