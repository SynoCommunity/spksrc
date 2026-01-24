PKG_NAME = opencl-clang
PKG_LLVM_MAJ = 14
PKG_VERS = $(PKG_LLVM_MAJ).0.5
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/opencl-clang/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# ocl-open-140 branch is still receiving updates
# using latest git hash to ensure replicable builds
#PKG_GIT_BRANCH = ocl-open-$(PKG_VERS)
#PKG_GIT_HASH = b8cd348820bd8df86c68d5c58540acd4ff426d2e
#PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
#PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
#PKG_DIR = $(PKG_NAME)-$(PKG_GIT_HASH)

HOMEPAGE = https://github.com/intel/opencl-clang
COMMENT  = opencl-clang is a thin wrapper library around clang. The library has OpenCL-oriented API and is capable to compile OpenCL C kernels to SPIR-V modules.
LICENSE  = Apache License v2.0 with LLVM Exceptions

REQUIRED_MIN_DSM = 7
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

# -----------------------------------------------------------------------------
# Dependencies
# -----------------------------------------------------------------------------
BUILD_DEPENDS  = native/llvm-14.0
BUILD_DEPENDS += cross/llvm-project-140.src
BUILD_DEPENDS += cross/Khronos-OpenCL-Headers
DEPENDS = cross/Khronos-SPIRV-LLVM-Translator-140

# -----------------------------------------------------------------------------
# Directories
# -----------------------------------------------------------------------------
LLVM_BIN_DIR = $(abspath $(PWD)/../../native/llvm-14.0/work-native/install/usr/local/bin)

# Add opencl-clang build (linux_resource_linker) + native LLVM tools to PATH
ENV += PATH=$(WORK_DIR)/$(PKG_DIR)/build/bin:$(LLVM_BIN_DIR):$$PATH

# -----------------------------------------------------------------------------
# Post-extract: create symlink so LLVM can find opencl-clang
# -----------------------------------------------------------------------------
POST_EXTRACT_TARGET = opencl-clang_post_extract_target
opencl-clang_post_extract_target:
	@cd $(WORK_DIR) && ln -sf $(PKG_DIR) $(PKG_NAME)

# -----------------------------------------------------------------------------
# CMake arguments
# -----------------------------------------------------------------------------
CMAKE_ARGS += -DLLVM_DIR=$(STAGING_INSTALL_PREFIX)/lib/cmake/llvm
CMAKE_ARGS += -DOPENCL_CLANG_BUILD_EXTERNAL=ON
CMAKE_ARGS += -DLLVMSPIRV_INCLUDED_IN_LLVM=OFF
CMAKE_ARGS += -DSPIRV_TRANSLATOR_DIR=$(STAGING_INSTALL_PREFIX)

# Use native LLVM tools to avoid circular dependencies
CMAKE_ARGS += -DLLVM_TABLEGEN_EXE=$(LLVM_BIN_DIR)/llvm-tblgen
CMAKE_ARGS += -DCLANG_COMMAND=$(LLVM_BIN_DIR)/clang

# [intel-opencl-clang-140]
CMAKE_ARGS += -DAPPLY_PATCHES='OFF'

# -----------------------------------------------------------------------------
# Reduce build-time binary size
# -----------------------------------------------------------------------------
GCC_NO_DEBUG_INFO = 1

# -----------------------------------------------------------------------------
# Include the common cross-cmake rules
# -----------------------------------------------------------------------------
include ../../mk/spksrc.cross-cmake.mk
