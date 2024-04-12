PKG_NAME = gpac
PKG_VERS = 2.2.1
PKG_REV = 1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/gpac/gpac/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://gpac.io
COMMENT  = Home of MP4Box.
LICENSE  = LGPLv2

# incompatible toolchain
UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS)

DEPENDS = cross/zlib

CONFIGURE_ARGS  = --enable-pic
CONFIGURE_ARGS += --extra-cflags="-Wno-pointer-sign"

PRE_COMPILE_TARGET = gpac_precompile

include ../../mk/spksrc.cross-cc.mk

.PHONY: gpac_precompile 
gpac_precompile:
	@echo "#define GPAC_GIT_REVISION \"$(PKG_REV) (SynoCommunity)\"" > $(WORK_DIR)/$(PKG_DIR)/include/gpac/revision.h
