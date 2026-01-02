PKG_NAME = llvm
PKG_VERS = 9.0.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-project-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/llvm/llvm-project/releases/download/llvmorg-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-project-$(PKG_VERS)

HOMEPAGE = https://llvm.org/
COMMENT = The LLVM Project is a collection of modular and reusable compiler and toolchain technologies.
LICENSE = Apache v2.0 with LLVM Exceptions

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

# -----------------------------------------------------------------------------
# Dependencies
# -----------------------------------------------------------------------------
DEPENDS += cross/zlib
CMAKE_ARGS += -DLLVM_ENABLE_ZLIB=ON

DEPENDS += cross/libffi
CMAKE_ARGS += LLVM_ENABLE_FFI=ON

DEPENDS += cross/ncursesw
CMAKE_ARGS += -DLLVM_ENABLE_TERMINFO=ON

DEPENDS += cross/libxml2
CMAKE_ARGS += -DLLVM_ENABLE_LIBXML2=ON

DEPENDS += cross/z3
CMAKE_ARGS += -DLLVM_ENABLE_Z3_SOLVER=ON
CMAKE_ARGS += -DLLVM_Z3_INSTALL_DIR=$(STAGING_INSTALL_PREFIX)
CMAKE_ARGS += -DZ3_RETURNCODE=0
CMAKE_ARGS += -DZ3_RETURNCODE__TRYRUN_OUTPUT=""

# -----------------------------------------------------------------------------
# Directories
# -----------------------------------------------------------------------------
CMAKE_DIR = $(WORK_DIR)/$(PKG_DIR)/llvm
LLVM_NATIVE_BUILD = $(WORK_DIR)/$(PKG_DIR)/build-native

include ../../mk/spksrc.common.mk

# -----------------------------------------------------------------------------
# Pre-Configure: Compile NATIVE mandatory tools later needed at build-time
# -----------------------------------------------------------------------------
PRE_CONFIGURE_TARGET = llvm_prebuild_native

.PHONY: llvm_prebuild_native
llvm_prebuild_native:
	@$(MSG) "Building native LLVM tools for cross-compilation..."
	@mkdir -p $(LLVM_NATIVE_BUILD)
	@env -i \
		PATH="/usr/bin:/bin:/usr/local/bin" \
		cmake -G Ninja \
			-S $(CMAKE_DIR) \
			-B $(LLVM_NATIVE_BUILD) \
		-DCMAKE_BUILD_TYPE=Release \
		-DLLVM_TARGETS_TO_BUILD=X86 \
		-DLLVM_ENABLE_PROJECTS="clang" \
		-DLLVM_BUILD_TOOLS=ON \
		-DLLVM_INCLUDE_TOOLS=ON \
		-DLLVM_BUILD_UTILS=ON \
		-DLLVM_ENABLE_WARNINGS=OFF \
		-Wno-dev
	@env -i \
		PATH="/usr/bin:/bin:/usr/local/bin" \
		ninja -C $(LLVM_NATIVE_BUILD) \
			llvm-config \
			llvm-tblgen \
			clang-tblgen \
			FileCheck

# Location of pre-built NATIVE tools:
#   FileCheck, llvm-config, llvm-tblgen, clang-tblgen
CMAKE_ARGS += -DLLVM_NATIVE_BUILD=$(LLVM_NATIVE_BUILD)
CMAKE_ARGS += -DLLVM_TOOLS_BINARY_DIR=$(LLVM_NATIVE_BUILD)/bin
CMAKE_ARGS += -DLLVM_CONFIG_PATH=$(LLVM_NATIVE_BUILD)/bin/llvm-config
CMAKE_ARGS += -DLLVM_EXTERNAL_LIT=$(LLVM_NATIVE_BUILD)/bin/FileCheck
CMAKE_ARGS += -DLLVM_TABLEGEN=$(LLVM_NATIVE_BUILD)/bin/llvm-tblgen
CMAKE_ARGS += -DCLANG_TABLEGEN=$(LLVM_NATIVE_BUILD)/bin/clang-tblgen

# -----------------------------------------------------------------------------
# CMake arguments - https://llvm.org/docs/CMake.html
# -----------------------------------------------------------------------------
CMAKE_ARGS += -DCMAKE_BUILD_TYPE=MinSizeRel
CMAKE_ARGS += -DCMAKE_CROSSCOMPILING=TRUE
CMAKE_ARGS += -DLLVM_DEFAULT_TARGET_TRIPLE=$(TC_TARGET)

# Suppress developer warnings
CMAKE_ARGS += -Wno-dev

# Disable LLVM's own extra warning flags
CMAKE_ARGS += -DLLVM_ENABLE_WARNINGS=OFF 

# Assertions are internal checks to help find bugs.
# They typically slow down LLVM and Clang when enabled
CMAKE_ARGS += -DLLVM_ENABLE_ASSERTIONS=OFF

# When set to ON it removes many of the LLVM development and
# testing tools as well as component libraries from the
# default install target. Including the development tools is
# not recommended for distributions as many of the LLCM tools
# are only intended for development and testing use.
CMAKE_ARGS += -DLLVM_INSTALL_TOOLCHAIN_ONLY=ON

# Only recommended for use by LLVM developers. To build
# LLVM as a shared library, use LLVM_BUILD_LLVM_DYLIB
CMAKE_ARGS += -DBUILD_SHARED_LIBS=OFF

# The most impactful way to reduce binary size is
# to dynamically link LLVM into all the tools.
# This reduces code size by decreasing duplication
# of common code between the LLVM-based tools.
CMAKE_ARGS += -DLLVM_BUILD_LLVM_DYLIB=ON
CMAKE_ARGS += -DLLVM_LINK_LLVM_DYLIB=ON

# Allow users to build with RTTI (Run-Time Type Info)
# enabled and still inherit from LLVM classes
CMAKE_ARGS += -DLLVM_ENABLE_RTTI=ON

# Disable tests
CMAKE_ARGS += -DCLANG_INCLUDE_DOCS=OFF
CMAKE_ARGS += -DCLANG_INCLUDE_TESTS=OFF
CMAKE_ARGS += -DLLVM_BUILD_TESTS=OFF
CMAKE_ARGS += -DLLVM_BUILD_DOCS=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_DOCS=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_EXAMPLES=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_TESTS=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_BENCHMARKS=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_GO_TESTS=OFF

include ../../mk/spksrc.cross-cmake.mk

ifeq ($(call version_lt, $(TC_GCC), 5),1)
CMAKE_ARGS += -DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=TRUE
CMAKE_ARGS += -DCOMPILER_RT_BUILD_LIBFUZZER=OFF
CMAKE_ARGS += -DZ3_VERSION_STRING=4.7.1
else
CMAKE_ARGS += -DZ3_VERSION_STRING=4.11.2
endif

# -----------------------------------------------------------------------------
# ARCH specific - https://llvm.org/docs/HowToCrossCompileBuiltinsOnArm.html
# -----------------------------------------------------------------------------
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=ARM

ifeq ($(call version_lt, $(TC_GCC), 5),1)
CMAKE_ARGS += -DLLVM_ENABLE_PROJECTS='clang;lld'
else
CMAKE_ARGS += -DLLVM_ENABLE_PROJECTS='clang;compiler-rt;lld'
CMAKE_ARGS += -DCOMPILER_RT_BUILD_BUILTINS=ON
CMAKE_ARGS += -DCOMPILER_RT_BUILD_PROFILE=OFF
CMAKE_ARGS += -DCOMPILER_RT_BUILD_SANITIZERS=OFF
CMAKE_ARGS += -DCOMPILER_RT_BUILD_XRAY=OFF
endif
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=AArch64
CMAKE_ARGS += -DLLVM_ENABLE_PROJECTS='clang;compiler-rt;lld'
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=X86
CMAKE_ARGS += -DLLVM_ENABLE_PROJECTS='clang;compiler-rt;lld'
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=X86
CMAKE_ARGS += -DLLVM_ENABLE_PROJECTS='clang;compiler-rt;lld'
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=PowerPC
CMAKE_ARGS += -DLLVM_ENABLE_PROJECTS='clang;compiler-rt;lld'
endif
