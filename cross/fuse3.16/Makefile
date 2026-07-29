PKG_NAME = fuse3
PKG_REAL_NAME = fuse
PKG_VERS = 3.16.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_REAL_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libfuse/libfuse/archive/
PKG_DIR = libfuse-$(PKG_REAL_NAME)-$(PKG_VERS)

# REMARKS:
# 3.16.2 is the latest version for ARMv5 and ARMv7L archs
# 3.17.0 will require stdatomic

OPTIONAL_DEPENDS = cross/libudev_204 cross/libudev_219

# libudev:
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

include ../../mk/spksrc.common.mk

ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
DEPENDS = cross/libudev_219
else
DEPENDS = cross/libudev_204
endif

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
PRE_CONFIGURE_TARGET = fuse3_add_missing_toolchain_file
endif

HOMEPAGE = https://github.com/libfuse/libfuse
COMMENT  = The reference implementation of the Linux FUSE (Filesystem in Userspace) interface.
LICENSE  = GPLv2, LGPLv2.1 (libfuse.so, libulockmgr.so)

CONFIGURE_ARGS  = -Dexamples=false
CONFIGURE_ARGS += -Duseroot=false

include ../../mk/spksrc.cross-meson.mk

.PHONY: fuse3_add_missing_toolchain_file
# workaround for arch-qoriq-6.2.4 and arch-88f6281-5.2
fuse3_add_missing_toolchain_file:
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/include/linux
	@install -m 755 src/securebits.h $(STAGING_INSTALL_PREFIX)/include/linux/
