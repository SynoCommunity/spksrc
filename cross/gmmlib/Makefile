PKG_NAME = gmmlib
PKG_VERS = 21.1.3
PKG_EXT = tar.gz
PKG_DIST_NAME = intel-$(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/gmmlib/archive
PKG_DIR = $(PKG_NAME)-intel-$(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libva

HOMEPAGE = https://github.com/intel/gmmlib
COMMENT  = Intel Graphics Memory Management Library provides device specific and buffer management for the Intel Graphics Compute Runtime for OpenCL and the Intel Media Driver for VAAPI.
LICENSE  = MIT

include ../../mk/spksrc.cross-cmake.mk
