PKG_NAME = intel-mediasdk
PKG_VERS = 23.2.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Intel-Media-SDK/MediaSDK/archive
PKG_DIR = MediaSDK-$(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/intel-media-driver

# Needs gcc >= 5: C++14 as gcc 4.9 does not implement it (aggregate/member initializers)
MIN_GCC_VERSION = 5

# The Intel media stack drives i915 ioctls the running kernel either has or has not;
# DSM 5.2's 3.2 kernel predates the render-node interface libva needs.
MIN_KERNEL_VERSION = 3.10

UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

HOMEPAGE = http://mediasdk.intel.com
COMMENT  = Intel Media SDK provides a plain C API to access hardware-accelerated video decode, encode and filtering on Intel® Gen graphics hardware platforms. Implementation written in C++ 11 with parts in C-for-Media (CM).
LICENSE  = MIT

include ../../mk/spksrc.cross-cmake.mk

# intel-mediasdk specific args
# for succesfull build
CONFIGURE_ARGS += -DMFX_PLUGINS_DIR=$(INSTALL_PREFIX)/lib
CONFIGURE_ARGS += -DBUILD_SAMPLES=OFF
CONFIGURE_ARGS += -DBUILD_TUTORIALS=OFF
