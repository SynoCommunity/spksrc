PKG_NAME = opencl-clang
PKG_LLVM_MAJ = 14
PKG_VERS = $(PKG_LLVM_MAJ)0
PKG_GIT_BRANCH = ocl-open-$(PKG_VERS)
PKG_EXT = tar.gz
PKG_DIST_SITE = https://github.com/intel/opencl-clang/archive

# ocl-open-140 branch is still receiving updates
# using latest git hash to ensure replicable builds
PKG_GIT_HASH = 470cf0018e1ef6fc92eda1356f5f31f7da452abc
PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_GIT_HASH)

# use below for direct ocl-open-140 branch
#PKG_DIST_NAME = $(PKG_GIT_BRANCH).$(PKG_EXT)
#PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
#PKG_DIR = $(PKG_NAME)-$(PKG_GIT_BRANCH)

REQUIRED_MIN_DSM = 7
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

BUILD_DEPENDS  = cross/llvm-140.src cross/clang-140.src cross/lld-140.src cross/libunwind-140.src
BUILD_DEPENDS += cross/SPIRV-LLVM-Translator-140.src cross/SPIRV-Headers.src
BUILD_DEPENDS += cross/intel-vc-intrinsics.src
DEPENDS += cross/SPIRV-Tools

HOMEPAGE = https://github.com/intel/opencl-clang
COMMENT  = opencl-clang is a thin wrapper library around clang. The library has OpenCL-oriented API and is capable to compile OpenCL C kernels to SPIR-V modules.
LICENSE  = Apache License v2.0 with LLVM Exceptions

POST_EXTRACT_TARGET = opencl-clang_post_extract_target

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

DEPENDS += cross/zlib
CMAKE_ARGS += -DLLVM_ENABLE_ZLIB=ON

# Assertions are internal checks to help find bugs.
# They typically slow down LLVM and Clang when enabled
CMAKE_ARGS += -DLLVM_ENABLE_ASSERTIONS=OFF

# BUILD_SHARED_LIBS is only recommended for use
# by LLVM developers. If you want to build LLVM
# as a shared library, you should use the
# LLVM_BUILD_LLVM_DYLIB option
CMAKE_ARGS += -DBUILD_SHARED_LIBS=OFF
CMAKE_ARGS += -DLLVM_BUILD_LLVM_DYLIB=ON
CMAKE_ARGS += -DLLVM_LINK_LLVM_DYLIB=ON

# Disable third-party benchmarks and unittest
# as not-included in build and fails
# --
# patch needed for LLVM 14.x
# https://github.com/llvm/llvm-project/issues/54941
CMAKE_ARGS += -DLLVM_INCLUDE_BENCHMARKS=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_TESTS=OFF

# Fix build failure against DSM-7.2 toolchain
#CMAKE_ARGS += -DLLVM_OPTIMIZED_TABLEGEN=ON

# intel-opencl-140 specific
CMAKE_ARGS += -DPREFERRED_LLVM_VERSION= $(PKG_LLVM_MAJ).0.5

# intel-vc-intrinsics dependent else error:
#   Could not find FOUND_VCS using the following files: VersionFromVCS.cmake
CMAKE_ARGS += -DFOUND_VCS=$(CMAKE_BUILD_DIR)/lib/cmake/llvm/VersionFromVCS.cmake

include ../../mk/spksrc.common.mk

#
# https://github.com/intel/opencl-clang
#
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=X86
CMAKE_ARGS += -DLLVM_ENABLE_PROJECTS='clang;lld'
CMAKE_ARGS += -DLLVM_SOURCE_DIR=$(WORK_DIR)/llvm
CMAKE_ARGS += -DLLVM_EXTERNAL_PROJECTS='llvm-spirv;opencl-clang;vc-intrinsics'
CMAKE_ARGS += -DLLVM_EXTERNAL_CLANG_SOURCE_DIR=$(WORK_DIR)/clang
CMAKE_ARGS += -DLLVM_EXTERNAL_LLVM_SPIRV_SOURCE_DIR=$(WORK_DIR)/SPIRV-LLVM-Translator
CMAKE_ARGS += -DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=$(WORK_DIR)/SPIRV-Headers
CMAKE_ARGS += -DLLVM_EXTERNAL_VC_INTRINSICS_SOURCE_DIR=$(WORK_DIR)/vc-intrinsics
CMAKE_ARGS += -DLLVM_EXTERNAL_OPENCL_CLANG_SOURCE_DIR=$(WORK_DIR)/$(PKG_NAME)

include ../../mk/spksrc.cross-cmake.mk

# Requires access to build-time NATIVE tools
ENV += PATH=$(CMAKE_BUILD_DIR)/NATIVE/bin:$$PATH

opencl-clang_post_extract_target:
	@cd $(WORK_DIR) && ln -s $(PKG_DIR) $(PKG_NAME)
