PKG_NAME = llvm
PKG_VERS = 21.1.8
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-project-$(PKG_VERS).src.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/llvm/llvm-project/releases/download/llvmorg-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-project-$(PKG_VERS).src

HOMEPAGE = https://llvm.org/
COMMENT = The LLVM Project is a collection of modular and reusable compiler and toolchain technologies.
LICENSE = Apache v2.0 with LLVM Exceptions

REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(PPC_ARCHS) comcerto2k
REQUIRED_MIN_SRM = 1.3

# -----------------------------------------------------------------------------
# Dependencies
# -----------------------------------------------------------------------------
DEPENDS += cross/zlib
CMAKE_ARGS += -DLLVM_ENABLE_ZLIB=ON

DEPENDS += cross/libffi
CMAKE_ARGS += -DLLVM_ENABLE_FFI=ON

DEPENDS += cross/libxml2
CMAKE_ARGS += -DCLANG_ENABLE_LIBXML2=ON
CMAKE_ARGS += -DLLVM_ENABLE_LIBXML2=ON

DEPENDS += cross/z3
CMAKE_ARGS += -DLLVM_ENABLE_Z3_SOLVER=ON

# -----------------------------------------------------------------------------
# Directories
# -----------------------------------------------------------------------------
CMAKE_DIR = $(WORK_DIR)/$(PKG_DIR)/llvm

# -----------------------------------------------------------------------------
# post-install
# -----------------------------------------------------------------------------
#POST_INSTALL_TARGET = llvm_post_install
#
#.PHONY: llvm_post_install
#llvm_post_install:
#	$(RUN) && cd $(STAGING_INSTALL_PREFIX)/bin && ln -s llvm-readobj llvm-readelf

# -----------------------------------------------------------------------------
# CMake arguments - https://llvm.org/docs/CMake.html
# -----------------------------------------------------------------------------
CMAKE_ARGS += -DCMAKE_BUILD_TYPE=MinSizeRel
CMAKE_ARGS += -DLLVM_ENABLE_PROJECTS='clang;lld'
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

# Remove build warnings
ADDITIONAL_CXXFLAGS  = -Wno-parentheses
ADDITIONAL_CXXFLAGS += -Wno-dangling-reference

include ../../mk/spksrc.cross-cmake.mk

# -----------------------------------------------------------------------------
# ARCH specific - https://llvm.org/docs/HowToCrossCompileBuiltinsOnArm.html
# -----------------------------------------------------------------------------
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=ARM
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=AArch64
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS) $(x64_ARCHS)),$(ARCH))
CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=X86
endif
