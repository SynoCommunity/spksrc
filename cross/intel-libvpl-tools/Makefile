PKG_NAME = libvpl-tools
PKG_VERS = 1.2.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/libvpl-tools/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/intel-mediasdk cross/intel-libvpl
REQUIRED_MIN_DSM = 7
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

HOMEPAGE = https://intel.github.io/libvpl/latest/index.html
COMMENT  = Intel® Video Processing Library (Intel® VPL) tools provide access to hardware accelerated video decode, encode, and frame processing capabilities on Intel® GPUs from the command line.
LICENSE  = MIT

CMAKE_ARGS += -DTOOLS_ENABLE_X11=OFF

include ../../mk/spksrc.cross-cmake.mk
