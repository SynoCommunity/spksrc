PKG_NAME = opencl-clang
PKG_VERS = 18.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/opencl-clang/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

REQUIRED_MIN_DSM = 7
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

BUILD_DEPENDS  = cross/llvm.src cross/clang.src cross/llvm-cmake.src
BUILD_DEPENDS += cross/SPIRV-LLVM-Translator.src cross/SPIRV-Headers.src
#BUILD_DEPENDS += cross/intel-vc-intrinsics.src
DEPENDS += cross/SPIRV-Tools

HOMEPAGE = https://github.com/intel/opencl-clang
COMMENT  = opencl-clang is a thin wrapper library around clang. The library has OpenCL-oriented API and is capable to compile OpenCL C kernels to SPIR-V modules.
LICENSE  = Apache License v2.0 with LLVM Exceptions

POST_EXTRACT_TARGET = opencl-clang_post_extract_target

# CMake 3.20.0 or higher is required
USE_NATIVE_CMAKE = 1

# Suppress developer warnings
CMAKE_ARGS += -Wno-dev

# Using various LLVM project sources needs a top-level master directory
CMAKE_BUILD_DIR = $(WORK_DIR)/opencl-clang.build
CMAKE_SOURCE_DIR = $(WORK_DIR)/llvm
CMAKE_DIR = $(WORK_DIR)/llvm

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

# Disable third-party benchmarks and unittest
# as not-included in build and fails
CMAKE_ARGS += -DLLVM_INCLUDE_BENCHMARKS=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_TESTS=OFF

include ../../mk/spksrc.common.mk

#
# https://github.com/intel/opencl-clang
#
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=X86
CMAKE_ARGS += -DLLVM_ENABLE_PROJECTS='clang'
CMAKE_ARGS += -DLLVM_EXTERNAL_PROJECTS='llvm-spirv;opencl-clang'
#CMAKE_ARGS += -DLLVM_EXTERNAL_PROJECTS='llvm-spirv;opencl-clang;vc-intrinsics'
CMAKE_ARGS += -DLLVM_EXTERNAL_LLVM_SPIRV_SOURCE_DIR=$(WORK_DIR)/SPIRV-LLVM-Translator
CMAKE_ARGS += -DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=$(WORK_DIR)/SPIRV-Headers
#CMAKE_ARGS += -DLLVM_EXTERNAL_VC_INTRINSICS_SOURCE_DIR=$(WORK_DIR)/vc-intrinsics
CMAKE_ARGS += -DLLVM_EXTERNAL_OPENCL_CLANG_SOURCE_DIR=$(WORK_DIR)/$(PKG_NAME)
endif

include ../../mk/spksrc.cross-cmake.mk

# Requires access to build-time NATIVE tools
ENV += PATH=$(CMAKE_BUILD_DIR)/NATIVE/bin:$$PATH

opencl-clang_post_extract_target:
	@cd $(WORK_DIR) && ln -s $(PKG_DIR) $(PKG_NAME)
