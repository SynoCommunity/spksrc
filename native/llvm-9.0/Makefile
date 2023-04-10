PKG_NAME = llvm
PKG_VERS = 9.0.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-project-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/llvm/llvm-project/releases/download/llvmorg-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-project-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = https://llvm.org/
COMMENT = The LLVM Project is a collection of modular and reusable compiler and toolchain technologies.
LICENSE  = Apache License v2.0 with LLVM Exceptions

CMAKE_USE_NINJA = 1
POST_INSTALL_TARGET = llvm_post_install

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
	$(RUN) install -m 755 build/bin/llvm-config $(STAGING_INSTALL_PREFIX)/bin/llvm-config
	$(RUN) install -m 755 build/bin/llvm-tblgen $(STAGING_INSTALL_PREFIX)/bin/llvm-tblgen
	$(RUN) install -m 755 build/bin/clang-tblgen $(STAGING_INSTALL_PREFIX)/bin/clang-tblgen
