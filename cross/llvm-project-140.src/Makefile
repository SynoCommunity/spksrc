PKG_NAME = llvm-project
PKG_VERS = 14.0.5
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).src.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/llvm/llvm-project/releases/download/llvmorg-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS).src

HOMEPAGE = https://llvm.org/
COMMENT = The LLVM Project is a collection of modular and reusable compiler and toolchain technologies
LICENSE = Apache v2.0 with LLVM Exceptions

# Limit to only needed files to reduce disk space usage
ADDITIONAL_EXTRACTFLAGS  = $(PKG_DIR)/clang
ADDITIONAL_EXTRACTFLAGS += $(PKG_DIR)/cmake
ADDITIONAL_EXTRACTFLAGS += $(PKG_DIR)/libunwind
ADDITIONAL_EXTRACTFLAGS += $(PKG_DIR)/lld
ADDITIONAL_EXTRACTFLAGS += $(PKG_DIR)/llvm
ADDITIONAL_EXTRACTFLAGS += $(PKG_DIR)/third-party
POST_EXTRACT_TARGET = clang_post_extract_target

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = nop

PATCHES_LEVEL = 1

include ../../mk/spksrc.cross-cmake.mk

.PHONY: clang_post_extract_target
clang_post_extract_target:
	@cd $(WORK_DIR) && ln -s $(PKG_DIR) $(PKG_NAME)
