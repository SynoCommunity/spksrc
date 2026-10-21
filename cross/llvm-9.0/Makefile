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
CONFIGURE_ARGS += -DLLVM_ENABLE_ZLIB=ON

DEPENDS += cross/libffi
CONFIGURE_ARGS += -DLLVM_ENABLE_FFI=ON

DEPENDS += cross/ncursesw
CONFIGURE_ARGS += -DLLVM_ENABLE_TERMINFO=ON

DEPENDS += cross/libxml2
CONFIGURE_ARGS += -DLLVM_ENABLE_LIBXML2=ON

DEPENDS += cross/z3
CONFIGURE_ARGS += -DLLVM_ENABLE_Z3_SOLVER=ON
CONFIGURE_ARGS += -DLLVM_Z3_INSTALL_DIR=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += -DZ3_RETURNCODE=0
CONFIGURE_ARGS += -DZ3_RETURNCODE__TRYRUN_OUTPUT=""

# -----------------------------------------------------------------------------
# Directories
# -----------------------------------------------------------------------------
CMAKE_DIR = $(WORK_DIR)/$(PKG_DIR)/llvm

# -----------------------------------------------------------------------------
# CMake arguments - https://llvm.org/docs/CMake.html
# -----------------------------------------------------------------------------
CONFIGURE_ARGS += -DCMAKE_BUILD_TYPE=MinSizeRel
CONFIGURE_ARGS += -DCMAKE_CROSSCOMPILING=TRUE
CONFIGURE_ARGS += -DLLVM_DEFAULT_TARGET_TRIPLE=$(TC_TARGET)
CONFIGURE_ARGS += -DCROSS_TOOLCHAIN_FLAGS_NATIVE=-DCMAKE_C_COMPILER=$$(which gcc)\;-DCMAKE_CXX_COMPILER=$$(which g++)

# Suppress developer warnings
CONFIGURE_ARGS += -Wno-dev

# Disable LLVM's own extra warning flags
CONFIGURE_ARGS += -DLLVM_ENABLE_WARNINGS=OFF

# Assertions are internal checks to help find bugs.
# They typically slow down LLVM and Clang when enabled
CONFIGURE_ARGS += -DLLVM_ENABLE_ASSERTIONS=OFF

# When set to ON it removes many of the LLVM development and
# testing tools as well as component libraries from the
# default install target. Including the development tools is
# not recommended for distributions as many of the LLCM tools
# are only intended for development and testing use.
CONFIGURE_ARGS += -DLLVM_INSTALL_TOOLCHAIN_ONLY=ON

# Only recommended for use by LLVM developers. To build
# LLVM as a shared library, use LLVM_BUILD_LLVM_DYLIB
CONFIGURE_ARGS += -DBUILD_SHARED_LIBS=OFF

# The most impactful way to reduce binary size is
# to dynamically link LLVM into all the tools.
# This reduces code size by decreasing duplication
# of common code between the LLVM-based tools.
CONFIGURE_ARGS += -DLLVM_BUILD_LLVM_DYLIB=ON
CONFIGURE_ARGS += -DLLVM_LINK_LLVM_DYLIB=ON

# Allow users to build with RTTI (Run-Time Type Info)
# enabled and still inherit from LLVM classes
CONFIGURE_ARGS += -DLLVM_ENABLE_RTTI=ON

# Disable tests
CONFIGURE_ARGS += -DCLANG_INCLUDE_DOCS=OFF
CONFIGURE_ARGS += -DCLANG_INCLUDE_TESTS=OFF
CONFIGURE_ARGS += -DLLVM_BUILD_TESTS=OFF
CONFIGURE_ARGS += -DLLVM_BUILD_DOCS=OFF
CONFIGURE_ARGS += -DLLVM_INCLUDE_DOCS=OFF
CONFIGURE_ARGS += -DLLVM_INCLUDE_EXAMPLES=OFF
CONFIGURE_ARGS += -DLLVM_INCLUDE_TESTS=OFF
CONFIGURE_ARGS += -DLLVM_INCLUDE_BENCHMARKS=OFF
CONFIGURE_ARGS += -DLLVM_INCLUDE_GO_TESTS=OFF

ADDITIONAL_CXXFLAGS  = -Wno-misleading-indentation
ADDITIONAL_CXXFLAGS += -Wno-stringop-overflow
ADDITIONAL_CXXFLAGS += -Wno-redundant-move
ADDITIONAL_CXXFLAGS += -Wno-init-list-lifetime
ADDITIONAL_CXXFLAGS += -Wno-range-loop-construct

include ../../mk/spksrc.cross-cmake.mk

ifeq ($(call version_lt, $(TC_GCC), 5),1)
  CONFIGURE_ARGS += -DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=TRUE
  CONFIGURE_ARGS += -DZ3_VERSION_STRING=4.7.1
else
  CONFIGURE_ARGS += -DZ3_VERSION_STRING=4.11.2
endif

# -----------------------------------------------------------------------------
# ARCH specific - https://llvm.org/docs/HowToCrossCompileBuiltinsOnArm.html
# -----------------------------------------------------------------------------

# Compiler run-time options:
#   - Applies to all DSM >= 7 with exception of comcerto2k (gcc-4.9)
#   - Applies to all DSM >= 6 with exception of ARMv7, and only partially supported by PPC
ifneq ($(or $(call version_gt,$(TC_GCC),5),$(filter-out $(ARMv7_ARCHS) $(ARMv7L_ARCHS) $(PPC_ARCHS),$(ARCH))),)
  CONFIGURE_ARGS += -DLLVM_ENABLE_PROJECTS='clang;compiler-rt;lld'
  CONFIGURE_ARGS += -DCOMPILER_RT_BUILD_BUILTINS=ON
  CONFIGURE_ARGS += -DCOMPILER_RT_BUILD_PROFILE=OFF
  CONFIGURE_ARGS += -DCOMPILER_RT_BUILD_LIBFUZZER=OFF
  CONFIGURE_ARGS += -DCOMPILER_RT_BUILD_MEMPROF=OFF
  CONFIGURE_ARGS += -DCOMPILER_RT_BUILD_SANITIZERS=OFF
  CONFIGURE_ARGS += -DCOMPILER_RT_BUILD_XRAY=OFF
else
  CONFIGURE_ARGS += -DLLVM_ENABLE_PROJECTS='clang;lld'
  PLIST_TRANSFORM = sed -e '/_rt\./d'
endif

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
  CONFIGURE_ARGS += -DLLVM_TARGETS_TO_BUILD=ARM
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
  CONFIGURE_ARGS += -DLLVM_TARGETS_TO_BUILD=AArch64
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
  CONFIGURE_ARGS += -DLLVM_TARGETS_TO_BUILD=X86
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
  CONFIGURE_ARGS += -DLLVM_TARGETS_TO_BUILD=X86
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
  CONFIGURE_ARGS += -DLLVM_TARGETS_TO_BUILD=PowerPC
endif
