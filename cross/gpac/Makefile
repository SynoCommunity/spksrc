PKG_NAME = gpac
PKG_VERS = 2.2.1
GPAC_GIT_REVISION = "1 (SynoCommunity)"
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/gpac/gpac/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://gpac.io
COMMENT  = Home of MP4Box.
LICENSE  = LGPLv2

# toolchains lacking atomic support
UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS)

DEPENDS = cross/zlib

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --enable-pic
# suppress some compiler warnings:
CONFIGURE_ARGS += --extra-cflags="-Wno-pointer-sign -Wno-array-bounds -Wno-maybe-uninitialized"

PRE_COMPILE_TARGET = gpac_pre_compile

include ../../mk/spksrc.cross-cc.mk

.PHONY: gpac_pre_compile 
gpac_pre_compile:
	@$(MSG) "Patch revision.h to avoid UNKNOWN_REV (used when build is not in gpac git repository)"
	@sed -e 's/"UNKNOWN_REV"/$(GPAC_GIT_REVISION)/' -i $(WORK_DIR)/$(PKG_DIR)/include/gpac/revision.h
