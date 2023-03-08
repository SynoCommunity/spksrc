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

# https://llvm.org/docs/CMake.html
CMAKE_ARGS += -DCMAKE_BUILD_TYPE=MinSizeRel
CMAKE_ARGS += -Wno-dev
CMAKE_ARGS += -DLLVM_BUILD_DOCS=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_BENCHMARKS=OFF
CMAKE_ARGS += -DLLVM_ENABLE_PROJECTS='clang;compiler-rt;lld;clang-tools-extra'

# When set to ON it removes many of the LLVM development and
# testing tools as well as component libraries from the
# default install target. Including the development tools is
# not recommended for distributions as many of the LLCM tools
# are only intended for development and testing use.
CMAKE_ARGS += -DLLVM_INSTALL_TOOLCHAIN_ONLY=ON

# Assertions are internal checks to help find bugs.
# They typically slow down LLVM and Clang when enabled
CMAKE_ARGS += -DLLVM_ENABLE_ASSERTIONS=OFF

# Enable building with zlib to support compression/uncompression
CMAKE_ARGS += -DLLVM_ENABLE_ZLIB=ON

# Indicates whether the LLVM Interpreter will be
# linked with the Foreign Function Interface library
# (libffi) in order to enable calling external functions.
# DEPENDS += cross/libffi
# CMAKE_ARGS += LLVM_ENABLE_FFI=ON                     <-- TO TEST

# BUILD_SHARED_LIBS is only recommended for use
# by LLVM developers. If you want to build LLVM
# as a shared library, you should use the
# LLVM_BUILD_LLVM_DYLIB option
# CMAKE_ARGS += -DBUILD_SHARED_LIBS=ON

# The most impactful way to reduce binary size is
# to dynamically link LLVM into all the tools.
# This reduces code size by decreasing duplication
# of common code between the LLVM-based tools.
CMAKE_ARGS += -DLLVM_BUILD_LLVM_DYLIB=ON
CMAKE_ARGS += -DLLVM_LINK_LLVM_DYLIB=ON

# Allow users to build with RTTI (Run-Time Type Info)
# enabled and still inherit from LLVM classes
#CMAKE_ARGS += -DLLVM_ENABLE_RTTI=ON                    <-- TO TEST

# Otherwise builds with error
CMAKE_ARGS += -DCOMPILER_RT_BUILD_LIBFUZZER=OFF

# This switch enables building for the r600 AMD GPU
# used by the Mesa r600 and radeonsi drivers.
# The BPF target is required to build v4l-utils-1.24.1.
# -DLLVM_TARGETS_TO_BUILD="AMDGPU;BPF"                 <-- Something to play with for CUDA and NVIDIA GPU transcoding?

# Requires native/llvm-9.0
CMAKE_ARGS += -DLLVM_CONFIG=$(abspath $(PWD)/../../native/llvm-9.0/work-native/install/usr/local/bin/llvm-config)
CMAKE_ARGS += -DLLVM_TABLEGEN=$(abspath $(PWD)/../../native/llvm-9.0/work-native/install/usr/local/bin/llvm-tblgen)
CMAKE_ARGS += -DCLANG_TABLEGEN=$(abspath $(PWD)/../../native/llvm-9.0/work-native/install/usr/local/bin/clang-tblgen)

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=ARM
CMAKE_ARGS += -DLLVM_DEFAULT_TARGET_TRIPLE=arm-marvell-linux-gnueabi
endif

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=ARM
CMAKE_ARGS += -DLLVM_DEFAULT_TARGET_TRIPLE=arm-unknown-linux-gnueabi
endif

ifeq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=ARM
CMAKE_ARGS += -DLLVM_DEFAULT_TARGET_TRIPLE=arm-cortexa9-linux-gnueabi
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=AArch64
CMAKE_ARGS += -DLLVM_DEFAULT_TARGET_TRIPLE=aarch64-unknown-linux-gnueabi
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=X86
CMAKE_ARGS += -DLLVM_DEFAULT_TARGET_TRIPLE=i686-pc-linux-gnu
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=X86
CMAKE_ARGS += -DLLVM_DEFAULT_TARGET_TRIPLE=x86_64-pc-linux-gnu
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=PPC64
CMAKE_ARGS += -DLLVM_DEFAULT_TARGET_TRIPLE=powerpc-e500v2-linux-gnuspe
CMAKE_ARGS += -DCMAKE_CXX_FLAGS=-m32
CMAKE_ARGS += -DENABLE_ALTIVEC=OFF
CMAKE_ARGS += -DCPU_POWER8=OFF
endif

include ../../mk/spksrc.cross-cmake.mk

ifeq ($(call version_lt, $(TC_GCC), 5.1),1)
CMAKE_ARGS += -DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=ON
endif
