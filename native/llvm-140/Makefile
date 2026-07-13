PKG_NAME = llvm-140
PKG_LLVM_MAJ = 14
PKG_VERS = $(PKG_LLVM_MAJ).0.6
PKG_DIR = llvm-project

HOMEPAGE = https://llvm.org/
COMMENT  = Collection of modular and reusable compiler and toolchain technologies.
LICENSE  = Apache-2.0 with LLVM-exception

DOWNLOAD_TARGET = nop
CHECKSUM_TARGET = nop

# -----------------------------------------------------------------------------
# Dependencies
# -----------------------------------------------------------------------------
BUILD_DEPENDS += cross/llvm-project-140.src

# -----------------------------------------------------------------------------
# Directories
# -----------------------------------------------------------------------------
CMAKE_BUILD_DIR = $(WORK_DIR)/$(PKG_NAME).build
CMAKE_SOURCE_DIR = $(WORK_DIR)/llvm-project/llvm

# -----------------------------------------------------------------------------
# Post-extract: create symlink so LLVM can find the translator
# -----------------------------------------------------------------------------
POST_INSTALL_TARGET = llvm_post_install_target
llvm_post_install_target:
	$(RUN) install -m 755 $(CMAKE_BUILD_DIR)/bin/clang-tblgen $(STAGING_INSTALL_PREFIX)/bin/clang-tblgen

# -----------------------------------------------------------------------------
# CMake arguments
# -----------------------------------------------------------------------------
CONFIGURE_ARGS += -DLLVM_TARGETS_TO_BUILD=X86
CONFIGURE_ARGS += -DCMAKE_BUILD_TYPE=MinSizeRel
CONFIGURE_ARGS += -DLLVM_ENABLE_PROJECTS='llvm;clang;lld'
CONFIGURE_ARGS += -DLLVM_ENABLE_RTTI=ON
CONFIGURE_ARGS += -DLLVM_ENABLE_EH=ON
CONFIGURE_ARGS += -DLLVM_BUILD_LLVM_DYLIB=ON
CONFIGURE_ARGS += -DLLVM_LINK_LLVM_DYLIB=ON
CONFIGURE_ARGS += -DBUILD_SHARED_LIBS=OFF

# intel-compute-runtime requires compressions support
CONFIGURE_ARGS += -DLLVM_ENABLE_ZLIB=ON

# Install headers
CONFIGURE_ARGS += -DLLVM_INCLUDE_TOOLS=ON

# Avoid building and/or installing unecessary tools
CONFIGURE_ARGS += -DLLVM_BUILD_TOOLS=ON
CONFIGURE_ARGS += -DCLANG_BUILD_TOOLS=ON
CONFIGURE_ARGS += -DLLVM_INSTALL_UTILS=ON
CONFIGURE_ARGS += -DLLVM_INSTALL_TOOLCHAIN_ONLY=OFF

# Build flags
CONFIGURE_ARGS += -DCLANG_INCLUDE_DOCS=OFF
CONFIGURE_ARGS += -DCLANG_INCLUDE_TESTS=OFF
CONFIGURE_ARGS += -DLLVM_BUILD_TESTS=OFF
CONFIGURE_ARGS += -DLLVM_INCLUDE_DOCS=OFF
CONFIGURE_ARGS += -DLLVM_INCLUDE_TESTS=OFF
CONFIGURE_ARGS += -DLLVM_INCLUDE_BENCHMARKS=OFF
CONFIGURE_ARGS += -DLLVM_INCLUDE_GO_TESTS=OFF
CONFIGURE_ARGS += -DLLVM_INCLUDE_UTILS=OFF
CONFIGURE_ARGS += -DLLVM_ENABLE_ASSERTIONS=OFF

# [llvm-libunwind]
# Required to copy libunwind/include/mach-o/compact_unwind_encoding.h

# Remove build warnings
NATIVE_CXXFLAGS  = -Wno-attributes
NATIVE_CXXFLAGS += -Wno-cast-function-type
NATIVE_CXXFLAGS += -Wno-enum-compare
NATIVE_CXXFLAGS += -Wno-nonnull
NATIVE_CXXFLAGS += -Wno-mismatched-new-delete
NATIVE_CXXFLAGS += -Wno-missing-template-keyword
NATIVE_CXXFLAGS += -Wno-pedantic
NATIVE_CXXFLAGS += -Wno-switch
NATIVE_CXXFLAGS += -Wno-unused-function
NATIVE_CXXFLAGS += -Wno-variadic-macros

# Docker build workaround
CONFIGURE_ARGS += -DCMAKE_CXX_VISIBILITY_PRESET=default

# -----------------------------------------------------------------------------
# Include the common cross-cmake rules
# -----------------------------------------------------------------------------
include ../../mk/spksrc.native-cmake.mk
