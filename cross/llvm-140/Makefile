PKG_NAME = llvm-140
PKG_LLVM_MAJ = 14
PKG_VERS = $(PKG_LLVM_MAJ).0.6
PKG_DIR = llvm-project

HOMEPAGE = https://llvm.org/
COMMENT  = Collection of modular and reusable compiler and toolchain technologies.
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
DEPENDS = cross/zlib

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
CONFIGURE_ARGS += -DLLVM_TARGETS_TO_BUILD=X86
CONFIGURE_ARGS += -DLLVM_ENABLE_PROJECTS='clang;lld'
CONFIGURE_ARGS += -DLLVM_ENABLE_RTTI=ON
CONFIGURE_ARGS += -DLLVM_ENABLE_EH=ON
CONFIGURE_ARGS += -DLLVM_BUILD_LLVM_DYLIB=ON
CONFIGURE_ARGS += -DLLVM_LINK_LLVM_DYLIB=ON
CONFIGURE_ARGS += -DBUILD_SHARED_LIBS=OFF

# Install headers
CONFIGURE_ARGS += -DLLVM_INCLUDE_TOOLS=ON

# intel-compute-runtime requires compressions support
CONFIGURE_ARGS += -DLLVM_ENABLE_ZLIB=ON

# Avoid building and/or installing unecessary tools
CONFIGURE_ARGS += -DLLVM_BUILD_TOOLS=ON
CONFIGURE_ARGS += -DCLANG_BUILD_TOOLS=ON
CONFIGURE_ARGS += -DLLVM_INSTALL_UTILS=OFF
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

# Required for rusticl https://docs.mesa3d.org/rusticl.html
CONFIGURE_ARGS += -DLLVM_ENABLE_DUMP=ON

# [llvm-libunwind]
# Required to copy libunwind/include/mach-o/compact_unwind_encoding.h

# Remove build warnings
ADDITIONAL_CXXFLAGS  = -Wno-attributes
ADDITIONAL_CXXFLAGS += -Wno-cast-function-type
ADDITIONAL_CXXFLAGS += -Wno-enum-compare
ADDITIONAL_CXXFLAGS += -Wno-pedantic
ADDITIONAL_CXXFLAGS += -Wno-switch
ADDITIONAL_CXXFLAGS += -Wno-unused-function
ADDITIONAL_CXXFLAGS += -Wno-variadic-macros

# -----------------------------------------------------------------------------
# Reduce build-time binary size
# -----------------------------------------------------------------------------
GCC_NO_DEBUG_INFO = 1

# -----------------------------------------------------------------------------
# Include the common cross-cmake rules
# -----------------------------------------------------------------------------
include ../../mk/spksrc.cross-cmake.mk
