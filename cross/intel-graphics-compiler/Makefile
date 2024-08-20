PKG_NAME = intel-graphics-compiler
PKG_VERS = 1.0.17384.9
#PKG_VERS = 1.0.17224.10
#PKG_VERS = 1.0.16900.23
PKG_EXT = tar.gz
PKG_DIST_NAME = igc-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/intel-graphics-compiler/archive
PKG_DIR = $(PKG_NAME)-igc-$(PKG_VERS)

REQUIRED_MIN_DSM = 7
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

BUILD_DEPENDS += cross/SPIRV-Headers.src
BUILD_DEPENDS += cross/SPIRV-LLVM-Translator-140.src
BUILD_DEPENDS += cross/intel-vc-intrinsics.src
BUILD_DEPENDS += cross/intel-opencl-clang-140.src
BUILD_DEPENDS += cross/llvm-project-140.src
#BUILD_DEPENDS += cross/llvm-140.src cross/clang-140.src cross/lld-140.src cross/libunwind-140.src
DEPENDS += cross/intel-level-zero
DEPENDS += cross/SPIRV-Tools

HOMEPAGE = https://github.com/oneapi-src/level-zero
COMMENT  = This project is part of the larger oneAPI project and contains copies of the Level Zero Specification API C/C++ header files, Level Zero Loader, Level Zero Validation Layer and Level Zero Tracing Layer
LICENSE  = MIT

POST_EXTRACT_TARGET = igc_post_extract_target

# Default version of LLVM used by IGC
IGC_LLVM_MAJ = 14
IGC_LLVM_VER = $(IGC_LLVM_MAJ).0.5

# Suppress developer warnings
CMAKE_ARGS += -Wno-dev

# Using various LLVM project sources needs a top-level master directory
CMAKE_BUILD_DIR = $(WORK_DIR)/igc.build
CMAKE_SOURCE_DIR = $(WORK_DIR)/igc
CMAKE_DIR = $(WORK_DIR)/igc

# Needed for IGC lldELF
#DEPENDS += cross/protobuf

# Indicates whether the LLVM Interpreter will be
# linked with the Foreign Function Interface library
# (libffi) in order to enable calling external functions.
DEPENDS += cross/libffi
CMAKE_ARGS += -DLLVM_ENABLE_FFI=ON

DEPENDS += cross/ncursesw
CMAKE_ARGS += -DLLVM_ENABLE_TERMINFO=ON

DEPENDS += cross/libxml2
CMAKE_ARGS += -DLLVM_ENABLE_LIBXML2=ON

# Enable building with zlib to support compression/uncompression
DEPENDS += cross/zlib
CMAKE_ARGS += -DLLVM_ENABLE_ZLIB=ON

# Assertions are internal checks to help find bugs.
# They typically slow down LLVM and Clang when enabled
CMAKE_ARGS += -DLLVM_ENABLE_ASSERTIONS=OFF

# BUILD_SHARED_LIBS is only recommended for use
# by LLVM developers. If you want to build LLVM
# as a shared library, you should use the
# LLVM_BUILD_LLVM_DYLIB option
CMAKE_ARGS += -DBUILD_SHARED_LIBS=OFF
#CMAKE_ARGS += -DLLVM_BUILD_LLVM_DYLIB=ON
#CMAKE_ARGS += -DLLVM_LINK_LLVM_DYLIB=ON

# Disable third-party benchmarks and unittest
# as not-included in build and fails
CMAKE_ARGS += -DLLVM_INCLUDE_BENCHMARKS=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_TESTS=OFF

# Required in conjunction with -DIGC_OPTION__USE_PREINSTALLED_SPIRV_HEADERS='ON'
CMAKE_ARGS += -DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=$(WORK_DIR)/SPIRV-Headers

# [intel-opencl-clang-140]
CMAKE_ARGS += -DAPPLY_PATCHES='OFF'

# [intel-vc-intrinsics] else error:
#   Could not find FOUND_VCS using the following files: VersionFromVCS.cmake
#CMAKE_ARGS += -DFOUND_VCS=$(CMAKE_BUILD_DIR)/lib/cmake/llvm/VersionFromVCS.cmake
CMAKE_ARGS += -DFOUND_VCS=$(CMAKE_BUILD_DIR)/IGC/llvm-deps-$(IGC_LLVM_VER)/build/src/lib/cmake/llvm/VersionFromVCS.cmake
#CMAKE_ARGS += -DFOUND_VCS=$(CMAKE_BUILD_DIR)/IGC/llvm-deps-$(IGC_LLVM_VER)/build/src/NATIVE/lib/cmake/llvm/VersionFromVCS.cmake

# IGC specific
CMAKE_ARGS += -DIGC_OPTION__ARCHITECTURE_TARGET='Linux64'
CMAKE_ARGS += -DIGC_OPTION__ARCHITECTURE_HOST='Linux64'
CMAKE_ARGS += -DIGC_OPTION__CLANG_MODE='Source'
CMAKE_ARGS += -DIGC_OPTION__CLANG_SOURCES_DIR:PATH=$(WORK_DIR)/llvm-project/clang
CMAKE_ARGS += -DIGC_OPTION__LLD_MODE='Source'
CMAKE_ARGS += -DIGC_OPTION__lld_SOURCES_DIR:PATH=$(WORK_DIR)/llvm-project/lld
CMAKE_ARGS += -DIGC_OPTION__LLVM_MODE='Source'
CMAKE_ARGS += -DIGC_OPTION__LLVM_STOCK_SOURCES=ON
CMAKE_ARGS += -DIGC_OPTION__LLVM_SOURCES_DIR=$(WORK_DIR)/llvm-project
CMAKE_ARGS += -DIGC_OPTION__LLVM_PREFERRED_VERSION='$(IGC_LLVM_VER)'
# Required to copy libunwind/include/mach-o/compact_unwind_encoding.h
CMAKE_ARGS += -DDEFAULT_IGC_LLVM_SOURCES_DIR=$(WORK_DIR)/llvm-project
# Required in conjunction with -DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR
CMAKE_ARGS += -DIGC_OPTION__USE_PREINSTALLED_SPIRV_HEADERS='ON'
CMAKE_ARGS += -DIGC_OPTION__LINK_KHRONOS_SPIRV_TRANSLATOR='ON'
CMAKE_ARGS += -DCCLANG_FROM_SYSTEM='OFF'
CMAKE_ARGS += -DINSTALL_GENX_IR='ON'

# [SPIRV-Tools]
# cannot be built in-tree: SPIRV-Tools requires C++17 or later, but is configured for C++14
CMAKE_ARGS += -DIGC_OPTION__SPIRV_TOOLS_MODE='Prebuilds'

# [SPIRV-LLVM-Translator -> llvm-spirv]
# Leave in auto-configure as otherwise fails
#CMAKE_ARGS += -DIGC_OPTION__SPIRV_TRANSLATOR_MODE='Source'
#CMAKE_ARGS += -DIGC_OPTION__SPIRV_TRANSLATOR_SOURCE_DIR=$(WORK_DIR)/SPIRV-LLVM-Translator

# [intel-vc-intrinsics]
# Leaving source directory in auto-configure mode du to CMake Warning:
#     Manually-specified variables were not used by the project: IGC_OPTION__VC_INTRINSICS_SOURCES_DIR
CMAKE_ARGS += -DIGC_OPTION__VC_INTRINSICS_MODE='Source'
#CMAKE_ARGS += -DIGC_OPTION__VC_INTRINSICS_SOURCES_DIR=$(WORK_DIR)/vc-intrinsics

CMAKE_ARGS += -DCMAKE_POLICY_DEFAULT_CMP0079='NEW'

ADDITIONAL_CXXFLAGS += -I$(WORK_DIR)/SPIRV-LLVM-Translator/include
ADDITIONAL_CXXFLAGS += -Wno-error=restrict
ADDITIONAL_CXXFLAGS += -Wno-error=deprecated-declarations

# Fails to access in NATIVE/bin due to parallel compiling
# llvm-tblgen provided thru native/llvm-9.0 instead
BUILD_DEPENDS += native/llvm-9.0
CMAKE_ARGS += -DLLVM_TABLEGEN=$(abspath $(PWD)/../../native/llvm-9.0/work-native/install/usr/local/bin/llvm-tblgen)

include ../../mk/spksrc.cross-cmake.mk

# Requires access to build-time NATIVE tools
ENV += PATH=$(CMAKE_BUILD_DIR)/IGC/llvm-deps-$(IGC_LLVM_VER)/build/src/NATIVE/bin:$$PATH

igc_link_external_project:
	@cd $(WORK_DIR)/llvm-project/llvm/projects && ln -sf ../../../opencl-clang opencl-clang
	@cd $(WORK_DIR)/llvm-project/llvm/projects && ln -sf ../../../SPIRV-LLVM-Translator llvm-spirv

igc_post_extract_target: igc_link_external_project
	@cd $(WORK_DIR) && ln -sf $(PKG_DIR) $(PKG_NAME)
	@cd $(WORK_DIR) && ln -sf $(PKG_NAME) igc
