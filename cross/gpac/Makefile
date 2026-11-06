PKG_NAME = gpac
PKG_VERS = 26.07.0
GPAC_GIT_REVISION = "1 (SynoCommunity)"
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/gpac/gpac/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://gpac.io
COMMENT  = Home of MP4Box.
LICENSE  = LGPLv2

# quickjs-libc includes stdatomic.h unconditionally, which needs GCC >= 4.9.
MIN_GCC_VERSION = 4.9
# The PPC toolchain headers lack SYS_DVBT2.
UNSUPPORTED_ARCHS = $(PPC_ARCHS)
UNSUPPORTED_ARCHS_REASON = PPC toolchain headers lack SYS_DVBT2

DEPENDS = cross/zlib

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --enable-pic
# suppress some compiler warnings:
CONFIGURE_ARGS += --extra-cflags="-Wno-pointer-sign -Wno-array-bounds -Wno-maybe-uninitialized"

PRE_COMPILE_TARGET = gpac_pre_compile

include ../../mk/spksrc.cross-cc.mk

.PHONY: gpac_pre_compile
gpac_pre_compile:
	@$(MSG) "Stamp the SynoCommunity revision into revision.h"
	@sed -e 's|^#define GPAC_GIT_REVISION .*|#define GPAC_GIT_REVISION $(GPAC_GIT_REVISION)|' -i $(WORK_DIR)/$(PKG_DIR)/include/gpac/revision.h
