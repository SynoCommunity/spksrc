PKG_NAME = libvpl
PKG_VERS = 2.13.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/libvpl/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/intel-mediasdk
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

HOMEPAGE = https://intel.github.io/libvpl/latest/index.html
COMMENT  = Intel® Video Processing Library (Intel® VPL) provides access to hardware accelerated video decode, encode, and processing capabilities on Intel® GPUs to support AI visual inference, media delivery, cloud gaming, and virtual desktop infrastructure use cases.
LICENSE  = MIT

include ../../mk/spksrc.cross-cmake.mk

ifeq ($(call version_lt, ${TC_GCC}, 5),1)
ADDITIONAL_CXXFLAGS += -std=c++11
endif
