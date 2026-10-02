PKG_NAME = libva
PKG_VERS = 2.23.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/libva/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libdrm

HOMEPAGE = https://01.org/vaapi
COMMENT  = Libva is an implementation for VA-API (Video Acceleration API).
LICENSE  = MIT

# The Intel media stack drives i915 ioctls the running kernel either has or has not;
# DSM 5.2's 3.2 kernel predates the render-node interface libva needs.
MIN_KERNEL_VERSION = 3.10

CONFIGURE_ARGS = -Ddriverdir=$(INSTALL_PREFIX)/lib

ADDITIONAL_CFLAGS = -Os

include ../../mk/spksrc.common.mk

# C99 loop declarations: gcc < 5 defaults to gnu89
ifeq ($(call version_lt,$(TC_GCC),5),1)
CONFIGURE_ARGS += -Dc_std=gnu99
endif

include ../../mk/spksrc.cross-meson.mk
