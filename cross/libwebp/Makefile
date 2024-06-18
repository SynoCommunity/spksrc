PKG_NAME = libwebp
PKG_VERS = 1.4.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/webmproject/libwebp/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/xz cross/libtiff cross/libjpeg cross/libpng cross/giflib

HOMEPAGE = https://developers.google.com/speed/webp
COMMENT  = WebP codec: library to encode and decode images in WebP format.
LICENSE  = https://github.com/webmproject/libwebp/blob/master/COPYING

CMAKE_USE_NINJA = 1

include ../../mk/spksrc.cross-cmake.mk

# gcc version below 5.x requires enforcing c11
# fallback to default for armv5 using older gcc
ifeq ($(call version_le, $(TC_GCC), 5)$(call version_gt,$(TC_GCC),4.7),11)
ADDITIONAL_CFLAGS += -std=c11
endif
