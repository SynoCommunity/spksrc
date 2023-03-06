PKG_NAME = llvm
PKG_VERS = 9.0.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-project-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/llvm/llvm-project/releases/download/llvmorg-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-project-$(PKG_VERS)

BUILD_DEPENDS = native/llvm-9.0
DEPENDS = cross/zlib

HOMEPAGE = https://llvm.org/
COMMENT = The LLVM Project is a collection of modular and reusable compiler and toolchain technologies.
LICENSE  = Apache License v2.0 with LLVM Exceptions

CMAKE_USE_NINJA = 1

# Using LLVM project source need to change to llvm sub-directory
CMAKE_DIR = $(WORK_DIR)/$(PKG_DIR)/llvm

CMAKE_ARGS += -DCMAKE_BUILD_TYPE=MinSizeRel
CMAKE_ARGS += -DLLVM_ENABLE_ASSERTIONS=ON
CMAKE_ARGS += -DLLVM_BUILD_LLVM_DYLIB=ON
CMAKE_ARGS += -DLLVM_LINK_LLVM_DYLIB=ON
CMAKE_ARGS += -DBUILD_SHARED_LIBS=OFF
CMAKE_ARGS += -DLLVM_INSTALL_TOOLCHAIN_ONLY=ON
CMAKE_ARGS += -DLLVM_ENABLE_ZLIB=ON
CMAKE_ARGS += -DLLVM_ENABLE_PROJECTS='clang;compiler-rt;lld;clang-tools-extra'
CMAKE_ARGS += -DLLVM_NATIVE_TOOL_DIR=$(abspath $(PWD)/../../native/llvm-9.0/work-native/install/usr/local/bin)

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=ARM
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=AArch64
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS) $(x64_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=X86
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=PPC64
CMAKE_ARGS += -DCMAKE_CXX_FLAGS=-m32
CMAKE_ARGS += -DENABLE_ALTIVEC=OFF
CMAKE_ARGS += -DCPU_POWER8=OFF
endif

include ../../mk/spksrc.cross-cmake.mk

ifeq ($(call version_lt, $(TC_GCC), 5.1),1)
CMAKE_ARGS += -DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=ON
endif
