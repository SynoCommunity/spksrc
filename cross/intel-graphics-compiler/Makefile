PKG_NAME = intel-graphics-compiler
PKG_VERS = 1.0.16900.23
PKG_EXT = tar.gz
PKG_DIST_NAME = igc-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/intel-graphics-compiler/archive
PKG_DIR = $(PKG_NAME)-igc-$(PKG_VERS)

REQUIRED_MIN_DSM = 7
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

BUILD_DEPENDS += cross/SPIRV-Headers.src
BUILD_DEPENDS += cross/intel-vc-intrinsics.src
DEPENDS  = cross/intel-opencl-clang-140
DEPENDS += cross/intel-level-zero

HOMEPAGE = https://github.com/oneapi-src/level-zero
COMMENT  = This project is part of the larger oneAPI project and contains copies of the Level Zero Specification API C/C++ header files, Level Zero Loader, Level Zero Validation Layer and Level Zero Tracing Layer
LICENSE  = MIT

POST_EXTRACT_TARGET = igc_post_extract_target

# Default version of LLVM used by IGC
IGC_LLVM_MAJ = 14
IGC_LLVM_VER = $(IGC_LLVM_MAJ).0.5

# CMake 3.20.0 or higher is required
#USE_NATIVE_CMAKE = 1

# Suppress developer warnings
CMAKE_ARGS += -Wno-dev

# Using various LLVM project sources needs a top-level master directory
#CMAKE_BUILD_DIR = $(WORK_DIR)/igc.build
#CMAKE_SOURCE_DIR = $(WORK_DIR)/intel-graphics-compiler
#CMAKE_DIR = $(WORK_DIR)/igc

# Needed for IGC lldELF
DEPENDS += cross/protobuf

# Disable third-party benchmarks and unittest
# as not-included in build and fails
#CMAKE_ARGS += -DLLVM_INCLUDE_BENCHMARKS=OFF
#CMAKE_ARGS += -DLLVM_INCLUDE_TESTS=OFF

# IGC specifics options
# Freely insipired from: https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=intel-graphics-compiler-git
CMAKE_ARGS += -DIGC_OPTION__ARCHITECTURE_TARGET='Linux64'
CMAKE_ARGS += -DIGC_OPTION__CLANG_MODE='Prebuilds'
#CMAKE_ARGS += -DIGC_OPTION__LLD_MODE='Source'
CMAKE_ARGS += -DIGC_OPTION__LLVM_MODE='Prebuilds'
CMAKE_ARGS += -DIGC_OPTION__LLVM_PREFERRED_VERSION='$(IGC_LLVM_VER)'
CMAKE_ARGS += -DIGC_OPTION__LINK_KHRONOS_SPIRV_TRANSLATOR='ON'
#CMAKE_ARGS += -DIGC_OPTION__LINK_KHRONOS_SPIRV_TRANSLATOR='OFF'
CMAKE_ARGS += -DIGC_OPTION__SPIRV_TOOLS_MODE='Prebuilds'
CMAKE_ARGS += -DIGC_OPTION__VC_INTRINSICS_MODE='Source'
CMAKE_ARGS += -DIGC_OPTION__VC_INTRINSICS_SOURCES_DIR=$(WORK_DIR)/vc-intrinsics
CMAKE_ARGS += -DCCLANG_FROM_SYSTEM='ON'
CMAKE_ARGS += -DFOUND_VCS=$(WORK_DIR)/opencl-clang.build/lib/cmake/llvm/VersionFromVCS.cmake
#CMAKE_ARGS += -DINSTALL_GENX_IR='OFF'
CMAKE_ARGS += -DINSTALL_GENX_IR='ON'

ADDITIONAL_CXXFLAGS += -I$(WORK_DIR)/SPIRV-LLVM-Translator/include
ADDITIONAL_CXXFLAGS += -Wno-error=restrict
ADDITIONAL_CXXFLAGS += -Wno-error=deprecated-declarations

include ../../mk/spksrc.cross-cmake.mk

# Requires access to build-time NATIVE tools
#ENV += PATH=$(WORK_DIR)/opencl-clang.build/NATIVE/bin:$(STAGING_INSTALL_PREFIX)/bin:$$PATH
ENV += PATH=$(WORK_DIR)/opencl-clang.build/NATIVE/bin:$$PATH
#ENV += PATH=$(STAGING_INSTALL_PREFIX)/bin:$$PATH
#ENV += PATH=$(STAGING_INSTALL_PREFIX):$$PATH
#ENV += PATH=$(WORK_DIR)/install/$(INSTALL_PREFIX)/bin:$$PATH

igc_post_extract_target:
	@cd $(WORK_DIR) && ln -s $(PKG_DIR) $(PKG_NAME)
	@cd $(WORK_DIR) && ln -s $(PKG_NAME) igc
