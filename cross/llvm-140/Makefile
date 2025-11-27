PKG_NAME = llvm-140
PKG_LLVM_MAJ = 14
PKG_VERS = $(PKG_LLVM_MAJ).0.5
PKG_DIR = llvm-project

HOMEPAGE = https://github.com/KhronosGroup/SPIRV-LLVM-Translator
COMMENT  = Tool and library for translation between LLVM IR and SPIR-V
LICENSE  = Apache-2.0 with LLVM-exception

REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)
DOWNLOAD_TARGET = nop
CHECKSUM_TARGET = nop

# -----------------------------------------------------------------------------
# Dependencies
# -----------------------------------------------------------------------------
BUILD_DEPENDS  = native/llvm-14.0
BUILD_DEPENDS += cross/llvm-project-140.src

# -----------------------------------------------------------------------------
# Directories
# -----------------------------------------------------------------------------
CMAKE_BUILD_DIR = $(WORK_DIR)/$(PKG_NAME).build
CMAKE_SOURCE_DIR = $(WORK_DIR)/llvm-project/llvm
LLVM_BIN_DIR = $(abspath $(PWD)/../../native/llvm-14.0/work-native/install/usr/local/bin)

# Add native LLVM tools to PATH
ENV += PATH=$(LLVM_BIN_DIR):$$PATH

# -----------------------------------------------------------------------------
# CMake arguments
# -----------------------------------------------------------------------------
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=X86
CMAKE_ARGS += -DCMAKE_BUILD_TYPE=MinSizeRel
CMAKE_ARGS += -DLLVM_ENABLE_PROJECTS='clang'
CMAKE_ARGS += -DLLVM_ENABLE_RTTI=ON
CMAKE_ARGS += -DLLVM_ENABLE_EH=ON
CMAKE_ARGS += -DLLVM_BUILD_LLVM_DYLIB=ON
CMAKE_ARGS += -DLLVM_LINK_LLVM_DYLIB=ON
CMAKE_ARGS += -DBUILD_SHARED_LIBS=OFF

# Use native LLVM tools to avoid:
#   - avoid circular dependencies
#   - conflicts with native/llvm causing shlib error
#CMAKE_ARGS += -DCLANG_TABLEGEN=$(LLVM_BIN_DIR)/clang-tblgen
#CMAKE_ARGS += -DLLVM_TABLEGEN=$(LLVM_BIN_DIR)/llvm-tblgen

# -----------------------------------------------------------------------------
# Post-install: create symlink native llvm-tblgen & clang-tblgen
# -----------------------------------------------------------------------------
POST_INSTALL_TARGET = llvm_post_install_target
llvm_post_install_target:
	@$(RUN) ln -sf $(LLVM_BIN_DIR)/clang-tblgen $(STAGING_INSTALL_PREFIX)/bin/clang-tblgen
	@$(RUN) mv -f $(STAGING_INSTALL_PREFIX)/bin/llvm-tblgen $(STAGING_INSTALL_PREFIX)/bin/llvm-tblgen.orig
	@$(RUN) ln -sf $(LLVM_BIN_DIR)/llvm-tblgen $(STAGING_INSTALL_PREFIX)/bin/llvm-tblgen

# Install headers
CMAKE_ARGS += -DLLVM_INCLUDE_TOOLS=ON

# Avoid building and/or installing unecessary tools
CMAKE_ARGS += -DLLVM_BUILD_TOOLS=ON
CMAKE_ARGS += -DCLANG_BUILD_TOOLS=ON
CMAKE_ARGS += -DLLVM_INSTALL_UTILS=OFF
CMAKE_ARGS += -DLLVM_INSTALL_TOOLCHAIN_ONLY=OFF

# Build flags
CMAKE_ARGS += -DCLANG_BUILD_TESTS=OFF
CMAKE_ARGS += -DCLANG_INCLUDE_DOCS=OFF
CMAKE_ARGS += -DCLANG_INCLUDE_TESTS=OFF
CMAKE_ARGS += -DLLVM_BUILD_TESTS=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_DOCS=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_TESTS=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_BENCHMARKS=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_GO_TESTS=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_UTILS=OFF
CMAKE_ARGS += -DLLVM_ENABLE_ASSERTIONS=OFF

# Remove build warnings
ADDITIONAL_CXXFLAGS  = -Wno-cast-function-type
ADDITIONAL_CXXFLAGS += -Wno-pedantic
ADDITIONAL_CXXFLAGS += -Wno-switch
ADDITIONAL_CXXFLAGS += -Wno-unused-function
ADDITIONAL_CXXFLAGS += -Wno-variadic-macros

# -----------------------------------------------------------------------------
# Include the common cross-cmake rules
# -----------------------------------------------------------------------------
include ../../mk/spksrc.cross-cmake.mk
