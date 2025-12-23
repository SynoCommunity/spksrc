PKG_NAME = intel-graphics-compiler
# Last supported version to match intel-compute-runtim 24.35 API
PKG_VERS = 1.0.17791.18
PKG_EXT = tar.gz
PKG_DIST_NAME = igc-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/intel-graphics-compiler/archive
PKG_DIR = $(PKG_NAME)-igc-$(PKG_VERS)

HOMEPAGE = https://github.com/oneapi-src/level-zero
COMMENT  = This project is part of the larger oneAPI project and contains copies of the Level Zero Specification API C/C++ header files, Level Zero Loader, Level Zero Validation Layer and Level Zero Tracing Layer
LICENSE  = MIT

REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

# -----------------------------------------------------------------------------
# Dependencies
# -----------------------------------------------------------------------------
DEPENDS += native/llvm-14.0
DEPENDS += cross/intel-opencl-clang-140
DEPENDS += cross/intel-vc-intrinsics
DEPENDS += cross/Khronos-SPIRV-Tools

# -----------------------------------------------------------------------------
# Directories for NATIVE LLVM
# -----------------------------------------------------------------------------
LLVM_BIN_DIR = $(abspath $(PWD)/../../native/llvm-14.0/work-native/install/usr/local/bin)
LLVM_LIB_DIR = $(abspath $(PWD)/../../native/llvm-14.0/work-native/install/usr/local/lib)

# -----------------------------------------------------------------------------
# Post-extract: create symlink to igc
# -----------------------------------------------------------------------------
POST_EXTRACT_TARGET = igc_post_extract_target
igc_post_extract_target:
	@cd $(WORK_DIR) && ln -sf $(PKG_DIR) $(PKG_NAME)
	@cd $(WORK_DIR) && ln -sf $(PKG_NAME) igc

# -----------------------------------------------------------------------------
# CMake arguments
# -----------------------------------------------------------------------------
# [llvm]
CMAKE_ARGS += -DIGC_OPTION__LLVM_MODE=Prebuilds
CMAKE_ARGS += -DLLVM_DIR=$(STAGING_INSTALL_PREFIX)/lib/cmake/llvm

# [Khronos-SPIRV-Headers]
CMAKE_ARGS += -DIGC_BUILD__SPIRV_ENABLED=ON
CMAKE_ARGS += -DIGC_OPTION__USE_PREINSTALLED_SPIRV_HEADERS='ON'

# [Khronos-SPIRV-Tools]
CMAKE_ARGS += -DIGC_OPTION__SPIRV_TOOLS_MODE='Prebuilds'

# [vc-intrinsics]
CMAKE_ARGS += -DIGC_BUILD__VC_ENABLED=ON
CMAKE_ARGS += -DIGC_OPTION__VC_INTRINSICS_MODE='Prebuilds'

# -----------------------------------------------------------------------------
# Access to native/llvm-14.0 spcific binaries
# -----------------------------------------------------------------------------
CMAKE_ARGS += -DCLANG_EXE=$(LLVM_BIN_DIR)/clang
CMAKE_ARGS += -DLLVM_AS_EXE=$(LLVM_BIN_DIR)/llvm-as
CMAKE_ARGS += -DLLVM_LINK_EXE=$(LLVM_BIN_DIR)/llvm-link
CMAKE_ARGS += -DLLVM_OPT_EXE=$(LLVM_BIN_DIR)/opt

# For native build-time tools to link against LLVM libraries
# 'CMCLTranslatorTool', 'elf_packager', 'vcb', 'libBiFManager.so', etc.
CMAKE_ARGS += -DCMAKE_BUILD_RPATH="$(LLVM_LIB_DIR)"

# -----------------------------------------------------------------------------
# Reduce build-time binary size
# -----------------------------------------------------------------------------
GCC_NO_DEBUG_INFO = 1

# -----------------------------------------------------------------------------
# Include the common cross-cmake rules
# -----------------------------------------------------------------------------
include ../../mk/spksrc.cross-cmake.mk

# Requires access to:
#   Build time (IGC/Release/CMCLTranslatorTool): 'CMCLTranslatorTool', 'elf_packager', 'vcb'
ENV += PATH=$(CMAKE_BUILD_DIR)/IGC/$(CMAKE_BUILD_TYPE):$$PATH
