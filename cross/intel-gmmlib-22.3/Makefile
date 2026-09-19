PKG_NAME = intel-gmmlib
PKG_VERS = 22.3.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/gmmlib/archive
PKG_DIR = gmmlib-$(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libva
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

HOMEPAGE = https://github.com/intel/gmmlib
COMMENT  = Intel Graphics Memory Management Library provides device specific and buffer management for the Intel Graphics Compute Runtime for OpenCL and the Intel Media Driver for VAAPI.
LICENSE  = MIT

CONFIGURE_ARGS += -DRUN_TEST_SUITE=OFF

# The Intel media stack drives i915 ioctls the running kernel either has or has not;
# DSM 5.2's 3.2 kernel predates the render-node interface libva needs.
MIN_KERNEL_VERSION = 3.10

include ../../mk/spksrc.cross-cmake.mk
