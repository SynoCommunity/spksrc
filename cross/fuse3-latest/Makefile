PKG_NAME = fuse3
PKG_REAL_NAME = fuse
PKG_VERS = 3.18.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_REAL_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libfuse/libfuse/archive/
PKG_DIR = libfuse-$(PKG_REAL_NAME)-$(PKG_VERS)

DEPENDS = cross/libudev

# Needs gcc >= 4.9: <stdatomic.h> (3.17.0+) missing below.
MIN_GCC_VERSION = 4.9

include ../../mk/spksrc.common.mk

# Kernel 2.6.32 headers do not export <linux/securebits.h> (present from 3.2 on).
ifeq ($(call version_lt, $(TC_KERNEL), 3.0),1)
PRE_CONFIGURE_TARGET = fuse3_add_missing_toolchain_file
endif

HOMEPAGE = https://github.com/libfuse/libfuse
COMMENT  = The reference implementation of the Linux FUSE (Filesystem in Userspace) interface.
LICENSE  = GPLv2, LGPLv2.1 (libfuse.so, libulockmgr.so)

CONFIGURE_ARGS  = -Dexamples=false
CONFIGURE_ARGS += -Duseroot=false

include ../../mk/spksrc.cross-meson.mk

.PHONY: fuse3_add_missing_toolchain_file
# workaround for toolchains on kernel 2.6.32 (i.e. qoriq-6.2.4)
fuse3_add_missing_toolchain_file:
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/include/linux
	@install -m 755 src/securebits.h $(STAGING_INSTALL_PREFIX)/include/linux/
