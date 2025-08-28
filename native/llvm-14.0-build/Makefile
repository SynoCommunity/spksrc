PKG_NAME = llvm
PKG_VERS = 14.0.5
PKG_VERS_MAJ = $(firstword $(subst ., ,$(PKG_VERS)))
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-project-$(PKG_VERS).src.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/llvm/llvm-project/releases/download/llvmorg-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-project-$(PKG_VERS).src

# REMARKS:
# Since it takes a huge amount of resources to build this, we started to host the 
# output on https://github.com/SynoCommunity/spksrc/releases/tag/native%2Fllvm
# 
# This Makefile is to build the native llvm
# and has one additional target to build the archive (make build-archive)
# 
# The main reason to build llvm from source is, that other prebuilt packages
# do not contain the binary "clang-tblgen" that is mandatory to build cross/llvm-14.0.

DEPENDS =

HOMEPAGE = https://llvm.org/
COMMENT = The LLVM Project is a collection of modular and reusable compiler and toolchain technologies.
LICENSE  = Apache License v2.0 with LLVM Exceptions

POST_INSTALL_TARGET = llvm_post_install
CMAKE_USE_NINJA = 1

# Using LLVM project source need to change to llvm sub-directory
CMAKE_DIR = $(WORK_DIR)/$(PKG_DIR)/llvm

CMAKE_ARGS += -DCMAKE_BUILD_TYPE=MinSizeRel
CMAKE_ARGS += -DLLVM_ENABLE_ASSERTIONS=ON
CMAKE_ARGS += -DLLVM_BUILD_LLVM_DYLIB=ON
CMAKE_ARGS += -DLLVM_LINK_LLVM_DYLIB=ON
CMAKE_ARGS += -DBUILD_SHARED_LIBS=OFF
CMAKE_ARGS += -DLLVM_INSTALL_TOOLCHAIN_ONLY=ON
CMAKE_ARGS += -DLLVM_ENABLE_PROJECTS='clang'
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=X86

include ../../mk/spksrc.native-cmake.mk

.PHONY: llvm_post_install
llvm_post_install:
	$(RUN) install -m 755 build/bin/clang-tblgen $(STAGING_INSTALL_PREFIX)/bin/clang-tblgen
	@cd $(STAGING_INSTALL_PREFIX)/bin && ln -sf clang-$(PKG_VERS_MAJ) clang-tool
	$(RUN) install -m 755 build/bin/llvm-config $(STAGING_INSTALL_PREFIX)/bin/llvm-config
	$(RUN) install -m 755 build/bin/llvm-link $(STAGING_INSTALL_PREFIX)/bin/llvm-link
	$(RUN) install -m 755 build/bin/llvm-tblgen $(STAGING_INSTALL_PREFIX)/bin/llvm-tblgen
	$(RUN) install -m 755 build/bin/opt $(STAGING_INSTALL_PREFIX)/bin/opt

.PHONY: build-archive
build-archive:
	@$(MSG) "Build archive of install folder"
ifeq ($(wildcard work-native/install/usr/local/bin/*),)
	$(error "Installation not found. Please call make first.")
endif
	cd work-native && tar -czf ../native-$(PKG_NAME)-$(PKG_VERS).tar.gz ./install/*
