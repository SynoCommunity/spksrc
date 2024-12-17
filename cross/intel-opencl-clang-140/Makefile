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

###
### This serves as test the sub-component builds
### needed in order to compile in-tree IGC needed
### dependencies.
###
### Optionally next iteration may use out-of-tree
### builds of IGC for easier management of dependendices
###

REQUIRED_MIN_DSM = 7
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

BUILD_DEPENDS  = cross/llvm-project-140.src
BUILD_DEPENDS += cross/Khronos-SPIRV-LLVM-Translator-140.src
BUILD_DEPENDS += cross/Khronos-SPIRV-Headers
BUILD_DEPENDS += cross/Khronos-OpenCL-Headers
# Cannot be built in-tree:
#     SPIRV-Tools requires C++17 or later, but is configured for C++14
DEPENDS += cross/Khronos-SPIRV-Tools

HOMEPAGE = https://github.com/intel/opencl-clang
COMMENT  = opencl-clang is a thin wrapper library around clang. The library has OpenCL-oriented API and is capable to compile OpenCL C kernels to SPIR-V modules.
LICENSE  = Apache License v2.0 with LLVM Exceptions

POST_EXTRACT_TARGET = opencl-clang_post_extract_target

# Does not fails but when built using Ninja and/or requires various CMP0??? such as:
#   CMAKE_ARGS += -DCMAKE_POLICY_DEFAULT_CMP0116='OLD|NEW'
CMAKE_USE_NINJA = 0

# Suppress developer warnings
CMAKE_ARGS += -Wno-dev

# Using various LLVM project sources needs a top-level master directory
CMAKE_BUILD_DIR = $(WORK_DIR)/opencl-clang.build
CMAKE_SOURCE_DIR = $(WORK_DIR)/llvm-project/llvm

# Assertions are internal checks to help find bugs.
# They typically slow down LLVM and Clang when enabled
CMAKE_ARGS += -DLLVM_ENABLE_ASSERTIONS=OFF

# BUILD_SHARED_LIBS is only recommended for use
# by LLVM developers. If you want to build LLVM
# as a shared library, you should use the
# LLVM_BUILD_LLVM_DYLIB option
CMAKE_ARGS += -DBUILD_SHARED_LIBS=OFF

# Disable third-party benchmarks and unittest
# as not-included in build and fails
# --
# patch needed for LLVM 14.x
# https://github.com/llvm/llvm-project/issues/54941
CMAKE_ARGS += -DLLVM_INCLUDE_BENCHMARKS=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_TESTS=OFF

# [intel-opencl-clang-140]
CMAKE_ARGS += -DAPPLY_PATCHES='OFF'

include ../../mk/spksrc.common.mk

#
# https://github.com/intel/opencl-clang
#
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=X86
CMAKE_ARGS += -DLLVM_ENABLE_PROJECTS='clang;lld'
CMAKE_ARGS += -DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=$(STAGING_INSTALL_PREFIX)/include
CMAKE_ARGS += -DLLVM_EXTERNAL_LLVM_SPIRV_SOURCE_DIR=$(WORK_DIR)/SPIRV-LLVM-Translator
CMAKE_ARGS += -DLLVM_EXTERNAL_OPENCL_CLANG_SOURCE_DIR=$(WORK_DIR)/$(PKG_NAME)

# Allow vc-intrinsics to be built out-of-tree from intel-opencl-clang
ifeq ($(strip $(VC_INTRINSICS_IN_TREE_INSTALL)),FALSE)
CMAKE_ARGS += -DLLVM_EXTERNAL_PROJECTS='llvm-spirv;opencl-clang'

# Allow vc-intrinsics to be built in-tree from intel-opencl-clang
else
BUILD_DEPENDS += cross/intel-vc-intrinsics.src
CMAKE_ARGS += -DLLVM_EXTERNAL_VC_INTRINSICS_SOURCE_DIR=$(WORK_DIR)/vc-intrinsics
CMAKE_ARGS += -DLLVM_EXTERNAL_PROJECTS='llvm-spirv;opencl-clang;vc-intrinsics'
CMAKE_ARGS += -DLLVM_GENX_INTRINSICS_IN_TREE_INSTALL=TRUE
endif

# Contrary to IGC does not fail to access in NATIVE/bin/llvm-tblgen but reduces built time and size
BUILD_DEPENDS += native/llvm-14.0
CMAKE_ARGS += -DLLVM_TABLEGEN=$(abspath $(PWD)/../../native/llvm-14.0/work-native/install/usr/local/bin/llvm-tblgen)
CMAKE_ARGS += -DCLANG_TABLEGEN=$(abspath $(PWD)/../../native/llvm-14.0/work-native/install/usr/local/bin/clang-tblgen)

include ../../mk/spksrc.cross-cmake.mk

# Requires access to build-time NATIVE and native/llvm-14.0 tools
ENV += PATH=$(CMAKE_BUILD_DIR)/NATIVE/bin:$(abspath $(PWD)/../../native/llvm-14.0/work-native/install/usr/local/bin):$$PATH

opencl-clang_post_extract_target:
	@cd $(WORK_DIR) && ln -s $(PKG_DIR) $(PKG_NAME)
