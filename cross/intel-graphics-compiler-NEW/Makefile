PKG_NAME = intel-graphics-compiler
# Last supported version to match intel-compute-runtim 24.35 API
PKG_VERS = 1.0.17537.20
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
DEPENDS += native/llvm-14.0-build
DEPENDS += cross/intel-level-zero
DEPENDS += cross/intel-opencl-clang-140
DEPENDS += cross/intel-vc-intrinsics
DEPENDS += cross/Khronos-SPIRV-Tools

# -----------------------------------------------------------------------------
# Directories
# -----------------------------------------------------------------------------
LLVM_BIN_DIR = $(abspath $(PWD)/../../native/llvm-14.0-build/work-native/install/usr/local/bin)
LLVM_LIB_DIR = $(abspath $(PWD)/../../native/llvm-14.0-build/work-native/install/usr/local/lib)
ENV += LD_LIBRARY_PATH=$(LLVM_LIB_DIR):$$LD_LIBRARY_PATH

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
CMAKE_ARGS += -DLLVM_DIR=$(STAGING_INSTALL_PREFIX)/lib/cmake/llvm

# Default version of LLVM used by IGC
IGC_LLVM_MAJ = 14
IGC_LLVM_VER = $(IGC_LLVM_MAJ).0.5

# Fails when built using Ninja and/or requires various CMP0??? such as:
#   CMAKE_ARGS += -DCMAKE_POLICY_DEFAULT_CMP0116='OLD|NEW'
CMAKE_USE_NINJA = 0

# IGC specific
CMAKE_ARGS += -DIGC_OPTION__ARCHITECTURE_TARGET='Linux64'
CMAKE_ARGS += -DIGC_OPTION__ARCHITECTURE_HOST='Linux64'

# [Khronos-SPIRV-Headers]
CMAKE_ARGS += -DIGC_OPTION__USE_PREINSTALLED_SPIRV_HEADERS='ON'
CMAKE_ARGS += -DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR:PATH=$(WORK_DIR)/SPIRV-Headers

# [Khronos-SPIRV-Tools]
CMAKE_ARGS += -DIGC_OPTION__SPIRV_TOOLS_MODE='Prebuilds'

# [llvm]
CMAKE_ARGS += -DIGC_OPTION__LLVM_MODE=Prebuilds

# [llvm-libunwind]
# Required to copy libunwind/include/mach-o/compact_unwind_encoding.h

# [vc-intrinsics]
CMAKE_ARGS += -DIGC_OPTION__LINK_VC_BACKEND='ON'
CMAKE_ARGS += -DIGC_OPTION__VC_INTRINSICS_MODE='Prebuilds'

# Fails to access in NATIVE/bin/llvm-tblgen possibly due to parallel compiling
CMAKE_ARGS += -DLLVM_TABLEGEN=$(LLVM_BIN_DIR)/llvm-tblgen
CMAKE_ARGS += -DCLANG_TABLEGEN=$(LLVM_BIN_DIR)/clang-tblgen
CMAKE_ARGS += -DCLANG_EXE=$(LLVM_BIN_DIR)/clang
CMAKE_ARGS += -DLLVM_AS_EXE=$(LLVM_BIN_DIR)/llvm-as
CMAKE_ARGS += -DLLVM_LINK_EXE=$(LLVM_BIN_DIR)/llvm-link
CMAKE_ARGS += -DLLVM_OPT_EXE=$(LLVM_BIN_DIR)/opt

# -----------------------------------------------------------------------------
# Include the common cross-cmake rules
# -----------------------------------------------------------------------------
include ../../mk/spksrc.cross-cmake.mk

# Requires access to:
#   CMCLTranslatorTool (during build time): IGC/Release/CMCLTranslatorTool
#   llvm-tblgen, clang-tool (symlink -> clang-14), llvm-link, opt: native/llvm-14.0
ENV += PATH=$(CMAKE_BUILD_DIR)/IGC/$(CMAKE_BUILD_TYPE):$(LLVM_BIN_DIR):$$PATH
CMAKE_ARGS += -DCMAKE_BUILD_RPATH="\$$ORIGIN:\$$ORIGIN/.."
