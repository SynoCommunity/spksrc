PKG_NAME = SPIRV-LLVM-Translator
PKG_LLVM_MAJ = 14
PKG_VERS = $(PKG_LLVM_MAJ).0.5
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/KhronosGroup/SPIRV-LLVM-Translator
COMMENT  = Tool and library for translation between LLVM IR and SPIR-V
LICENSE  = Apache-2.0 with LLVM-exception

REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

# -----------------------------------------------------------------------------
# Dependencies
# -----------------------------------------------------------------------------
BUILD_DEPENDS = cross/llvm-project-140.src
DEPENDS  = cross/Khronos-SPIRV-Headers
DEPENDS += cross/Khronos-SPIRV-Tools
NATIVE_DEPENDS = native/llvm-14.0

# -----------------------------------------------------------------------------
# Directories
# -----------------------------------------------------------------------------
CMAKE_BUILD_DIR = $(WORK_DIR)/llvm-spirv.build
CMAKE_SOURCE_DIR = $(WORK_DIR)/llvm-project/llvm
LLVM_BIN_DIR = $(abspath $(PWD)/../../native/llvm-14.0/work-native/install/usr/local/bin)

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
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=X86
CMAKE_ARGS += -DLLVM_ENABLE_PROJECTS='clang'

CMAKE_ARGS += -DLLVM_EXTERNAL_PROJECTS='llvm-spirv'
CMAKE_ARGS += -DLLVM_ENABLE_RTTI=ON
CMAKE_ARGS += -DLLVM_ENABLE_EH=ON
CMAKE_ARGS += -DLLVM_EXTERNAL_LLVM_SPIRV_SOURCE_DIR=$(WORK_DIR)/SPIRV-LLVM-Translator
CMAKE_ARGS += -DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=$(STAGING_INSTALL_PREFIX)/include/spirv

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

# -----------------------------------------------------------------------------
# Include the common cross-cmake rules
# -----------------------------------------------------------------------------
include ../../mk/spksrc.cross-cmake.mk
