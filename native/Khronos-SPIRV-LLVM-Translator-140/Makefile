PKG_NAME = SPIRV-LLVM-Translator
PKG_LLVM_MAJ = 14
PKG_VERS = $(PKG_LLVM_MAJ).0.18
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/KhronosGroup/SPIRV-LLVM-Translator
COMMENT  = Tool and library for translation between LLVM IR and SPIR-V
LICENSE  = Apache-2.0 with LLVM-exception

# -----------------------------------------------------------------------------
# Dependencies
# -----------------------------------------------------------------------------
BUILD_DEPENDS   = cross/llvm-project-140.src
NATIVE_DEPENDS += native/llvm-140
NATIVE_DEPENDS += native/Khronos-SPIRV-Headers
NATIVE_DEPENDS += native/Khronos-SPIRV-Tools

# -----------------------------------------------------------------------------
# Directories
# -----------------------------------------------------------------------------
LLVM_BIN_DIR = $(abspath $(PWD)/../../native/llvm-14.0-build/work-native/install/usr/local/bin)

# Add native LLVM tools to PATH
ENV += PATH=$(LLVM_BIN_DIR):$$PATH

# -----------------------------------------------------------------------------
# Post-extract: create symlink so LLVM can find the translator
# -----------------------------------------------------------------------------
POST_EXTRACT_TARGET = llvm_spirv_post_extract_target
llvm_spirv_post_extract_target:
	@cd $(WORK_DIR) && ln -sf $(PKG_DIR) $(PKG_NAME)
	@cd $(WORK_DIR)/llvm-project/llvm/projects && ln -sf ../../../$(PKG_DIR) llvm-spirv

# -----------------------------------------------------------------------------
# CMake arguments
# -----------------------------------------------------------------------------
CMAKE_ARGS += -DLLVM_DIR=$(STAGING_INSTALL_PREFIX)/lib/cmake/llvm
CMAKE_ARGS += -DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=$(STAGING_INSTALL_PREFIX)/include
CMAKE_ARGS += -DBUILD_SHARED_LIBS=ON

# Remove build warnings
NATIVE_CXXFLAGS = -Wno-maybe-uninitialized

# -----------------------------------------------------------------------------
# Include the common cross-cmake rules
# -----------------------------------------------------------------------------
include ../../mk/spksrc.native-cmake.mk
