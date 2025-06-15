PKG_NAME = llvm
PKG_VERS = 16.0.6
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-project-$(PKG_VERS).src.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/llvm/llvm-project/releases/download/llvmorg-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-project-$(PKG_VERS).src

HOMEPAGE = https://llvm.org/
COMMENT = The LLVM Project is a collection of modular and reusable compiler and toolchain technologies
LICENSE = Apache v2.0 with LLVM Exceptions

REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(PPC_ARCHS) comcerto2k
CMAKE_USE_NINJA = 1

POST_INSTALL_TARGET = llvm_post_install

# Using LLVM project source need to change to llvm sub-directory
CMAKE_DIR = $(WORK_DIR)/$(PKG_DIR)/llvm

# https://llvm.org/docs/CMake.html
CMAKE_ARGS += -DCMAKE_BUILD_TYPE=MinSizeRel
CMAKE_ARGS += -Wno-dev
CMAKE_ARGS += -DLLVM_BUILD_DOCS=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_DOCS=OFF
CMAKE_ARGS += -DLLVM_ENABLE_WARNINGS=OFF 
CMAKE_ARGS += -DLLVM_INCLUDE_EXAMPLES=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_TESTS=OFF 
CMAKE_ARGS += -DLLVM_INCLUDE_BENCHMARKS=OFF
CMAKE_ARGS += -DLLVM_DEFAULT_TARGET_TRIPLE=$(TC_TARGET)

# Enable building with zlib to support compression/uncompression
DEPENDS += cross/zlib
CMAKE_ARGS += -DLLVM_ENABLE_ZLIB=ON

# Indicates whether the LLVM Interpreter will be
# linked with the Foreign Function Interface library
# (libffi) in order to enable calling external functions.
DEPENDS += cross/libffi
CMAKE_ARGS += -DLLVM_ENABLE_FFI=ON

DEPENDS += cross/ncursesw
CMAKE_ARGS += -DLLVM_ENABLE_TERMINFO=ON

DEPENDS += cross/libxml2
CMAKE_ARGS += -DLLVM_ENABLE_LIBXML2=ON

# When set to ON it removes many of the LLVM development and
# testing tools as well as component libraries from the
# default install target. Including the development tools is
# not recommended for distributions as many of the LLCM tools
# are only intended for development and testing use.
CMAKE_ARGS += -DLLVM_INSTALL_TOOLCHAIN_ONLY=ON

# Assertions are internal checks to help find bugs.
# They typically slow down LLVM and Clang when enabled
CMAKE_ARGS += -DLLVM_ENABLE_ASSERTIONS=OFF

# BUILD_SHARED_LIBS is only recommended for use
# by LLVM developers. If you want to build LLVM
# as a shared library, you should use the
# LLVM_BUILD_LLVM_DYLIB option
# CMAKE_ARGS += -DBUILD_SHARED_LIBS=ON
CMAKE_ARGS += -DBUILD_SHARED_LIBS=OFF

# The most impactful way to reduce binary size is
# to dynamically link LLVM into all the tools.
# This reduces code size by decreasing duplication
# of common code between the LLVM-based tools.
CMAKE_ARGS += -DLLVM_BUILD_LLVM_DYLIB=ON
CMAKE_ARGS += -DLLVM_LINK_LLVM_DYLIB=ON

# Allow users to build with RTTI (Run-Time Type Info)
# enabled and still inherit from LLVM classes
CMAKE_ARGS += -DLLVM_ENABLE_RTTI=ON

include ../../mk/spksrc.common.mk

#
# https://llvm.org/docs/HowToCrossCompileBuiltinsOnArm.html
#
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=ARM
CMAKE_ARGS += -DLLVM_ENABLE_PROJECTS='clang;compiler-rt;lld'
CMAKE_ARGS += -DCOMPILER_RT_BUILD_BUILTINS=ON
CMAKE_ARGS += -DCOMPILER_RT_BUILD_PROFILE=OFF
CMAKE_ARGS += -DCOMPILER_RT_BUILD_SANITIZERS=OFF
CMAKE_ARGS += -DCOMPILER_RT_BUILD_XRAY=OFF
endif

ifeq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=ARM
CMAKE_ARGS += -DLLVM_ENABLE_PROJECTS='clang;lld'
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=AArch64
CMAKE_ARGS += -DLLVM_ENABLE_PROJECTS='clang;compiler-rt;lld'
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=X86
CMAKE_ARGS += -DLLVM_ENABLE_PROJECTS='clang;compiler-rt;lld'
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=X86
CMAKE_ARGS += -DLLVM_ENABLE_PROJECTS='clang;compiler-rt;lld'
endif

include ../../mk/spksrc.cross-cmake.mk

.PHONY: llvm_post_install
llvm_post_install:
	$(RUN) && cd $(STAGING_INSTALL_PREFIX)/bin && ln -s llvm-readobj llvm-readelf
