PKG_NAME = libultrahdr
PKG_VERS = 1.5.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/google/libultrahdr/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libjpeg

# Requires C++ compiler, supporting at least C++17.
REQUIRED_MIN_DSM = 7.0
# C++17 support is only complete in gcc 7 or newer.
MIN_GCC_VERSION = 7

HOMEPAGE = https://developer.android.com/media/platform/hdr-image-format
COMMENT  = Ultra HDR is a true HDR image format, and is backcompatible. libultrahdr is the reference codec for the Ultra HDR format. The codecs that support the format can render the HDR intent of the image on HDR displays; other codecs can still decode and display the SDR intent of the image.
LICENSE  = Apache 2.0

CONFIGURE_ARGS += -DUHDR_BUILD_EXAMPLES=OFF

include ../../mk/spksrc.cross-cmake.mk
