PKG_NAME = opencl-clang
PKG_LLVM_MAJ = 14
PKG_VERS = $(PKG_LLVM_MAJ)0
PKG_GIT_BRANCH = ocl-open-$(PKG_VERS)
PKG_EXT = tar.gz
PKG_DIST_SITE = https://github.com/intel/opencl-clang/archive

# ocl-open-140 branch is still receiving updates
# using latest git hash to ensure replicable builds
PKG_GIT_HASH = b8cd348820bd8df86c68d5c58540acd4ff426d2e
PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_GIT_HASH)

# use below for direct ocl-open-140 branch
#PKG_DIST_NAME = $(PKG_GIT_BRANCH).$(PKG_EXT)
#PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
#PKG_DIR = $(PKG_NAME)-$(PKG_GIT_BRANCH)

HOMEPAGE = https://github.com/intel/opencl-clang
COMMENT  = opencl-clang is a thin wrapper library around clang. The library has OpenCL-oriented API and is capable to compile OpenCL C kernels to SPIR-V modules.
LICENSE  = Apache License v2.0 with LLVM Exceptions

REQUIRED_MIN_DSM = 7
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

###
### This serves as test the sub-component builds
### needed in order to compile in-tree IGC needed
### dependencies.
###
### Optionally next iteration may use out-of-tree
### builds of IGC for easier management of dependendices
###

# -----------------------------------------------------------------------------
# Dependencies
# -----------------------------------------------------------------------------
BUILD_DEPENDS  = cross/llvm-project-140.src
BUILD_DEPENDS += cross/Khronos-SPIRV-LLVM-Translator-140.src
BUILD_DEPENDS += cross/Khronos-SPIRV-Headers
BUILD_DEPENDS += cross/Khronos-OpenCL-Headers
DEPENDS += cross/Khronos-SPIRV-Tools
BUILD_DEPENDS += native/llvm-14.0

# -----------------------------------------------------------------------------
# Directories
# -----------------------------------------------------------------------------
CMAKE_BUILD_DIR = $(WORK_DIR)/opencl-clang.build
CMAKE_SOURCE_DIR = $(WORK_DIR)/llvm-project/llvm
LLVM_BIN_DIR = $(abspath $(PWD)/../../native/llvm-14.0/work-native/install/usr/local/bin)

# -----------------------------------------------------------------------------
# Post-extract: create symlink so LLVM can find opencl-clang
# -----------------------------------------------------------------------------
POST_EXTRACT_TARGET = opencl-clang_post_extract_target
opencl-clang_post_extract_target:
	@cd $(WORK_DIR) && ln -sf $(PKG_DIR) $(PKG_NAME)

# -----------------------------------------------------------------------------
# CMake arguments
# -----------------------------------------------------------------------------
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=X86
CMAKE_ARGS += -DLLVM_ENABLE_PROJECTS='clang'

CMAKE_ARGS += -DLLVM_EXTERNAL_PROJECTS='llvm-spirv;opencl-clang'
CMAKE_ARGS += -DLLVM_ENABLE_RTTI=ON
CMAKE_ARGS += -DLLVM_ENABLE_EH=ON
CMAKE_ARGS += -DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=$(STAGING_INSTALL_PREFIX)/include
CMAKE_ARGS += -DLLVM_EXTERNAL_LLVM_SPIRV_SOURCE_DIR=$(WORK_DIR)/SPIRV-LLVM-Translator
CMAKE_ARGS += -DLLVM_EXTERNAL_OPENCL_CLANG_SOURCE_DIR=$(WORK_DIR)/$(PKG_NAME)

# [intel-opencl-clang-140]
CMAKE_ARGS += -DAPPLY_PATCHES='OFF'

# Use native LLVM tools to avoid circular dependencies
CMAKE_ARGS += -DLLVM_TABLEGEN=$(LLVM_BIN_DIR)/llvm-tblgen
CMAKE_ARGS += -DCLANG_TABLEGEN=$(LLVM_BIN_DIR)/clang-tblgen

# Does not fails but when built using Ninja and/or requires various CMP0??? such as:
#   CMAKE_ARGS += -DCMAKE_POLICY_DEFAULT_CMP0116='OLD|NEW'
CMAKE_USE_NINJA = 0

# Enforce static build
CMAKE_ARGS += -DLLVM_BUILD_LLVM_DYLIB=OFF
CMAKE_ARGS += -DBUILD_SHARED_LIBS=OFF

# Build flags
CMAKE_ARGS += -DLLVM_ENABLE_ASSERTIONS=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_BENCHMARKS=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_TESTS=OFF
CMAKE_ARGS += -DLLVM_BUILD_TESTS=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_GO_TESTS=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_UTILS=OFF

# Suppress developer warnings
CMAKE_ARGS += -Wno-dev

include ../../mk/spksrc.cross-cmake.mk
