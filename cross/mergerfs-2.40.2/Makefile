PKG_NAME = mergerfs
PKG_VERS = 2.40.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/trapexit/mergerfs/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# C++11: gcc 4.7.3 and older stop in its fmt copy and on -std=c++11.
MIN_GCC_VERSION = 4.8
# O_TMPFILE, which glibc defines from 2.19 on.
MIN_GLIBC_VERSION = 2.19

HOMEPAGE = https://trapexit.github.io/mergerfs/
COMMENT  = mergerfs - a featureful union filesystem.
LICENSE  = ISC

CONFIGURE_TARGET = nop
PRE_COMPILE_TARGET = mergerfs_pre_compile

# needs uppercase PREFIX
INSTALL_ARGS = install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk

# when package is not already built:
ifeq ($(wildcard $(COMPILE_COOKIE)),)
# mergerfs comes with its own (statically linked) libfuse, and fails to build
# while using the installed fuse.h (of different version)
ifneq ($(wildcard $(STAGING_INSTALL_PREFIX)/include/fuse.h),)
$(error "mergerfs fails to build when cross/fuse is built before.")
endif
endif

.PHONY: mergerfs_pre_compile
mergerfs_pre_compile:
	@$(MSG) "Create version file"
	@echo "$(PKG_VERS)" > $(WORK_DIR)/$(PKG_DIR)/VERSION 
