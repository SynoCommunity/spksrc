PKG_NAME = intel-graphics-compiler
PKG_VERS = 1.0.17537.20
PKG_EXT = tar.gz
PKG_DIST_NAME = igc-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/intel-graphics-compiler/archive
PKG_DIR = $(PKG_NAME)-igc-$(PKG_VERS)

REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

DEPENDS += cross/intel-level-zero

HOMEPAGE = https://github.com/oneapi-src/level-zero
COMMENT  = This project is part of the larger oneAPI project and contains copies of the Level Zero Specification API C/C++ header files, Level Zero Loader, Level Zero Validation Layer and Level Zero Tracing Layer
LICENSE  = MIT

# Default version of LLVM used by IGC
IGC_LLVM_MAJ = 14
IGC_LLVM_VER = $(IGC_LLVM_MAJ).0.5

POST_EXTRACT_TARGET = igc_post_extract_target

# Fails when built using Ninja and/or requires various CMP0??? such as:
#   CMAKE_ARGS += -DCMAKE_POLICY_DEFAULT_CMP0116='OLD|NEW'
CMAKE_USE_NINJA = 0

# Limit compile/link-time storage space (and faster build-time)
GCC_NO_DEBUG_INFO = 1

# Using various LLVM project sources needs a top-level master directory
CMAKE_BUILD_DIR = $(WORK_DIR)/igc.build
CMAKE_SOURCE_DIR = $(WORK_DIR)/igc
CMAKE_DIR = $(WORK_DIR)/igc

# Assertions are internal checks to help find bugs.
# They typically slow down LLVM and Clang when enabled
CMAKE_ARGS += -DLLVM_ENABLE_ASSERTIONS=OFF

# BUILD_SHARED_LIBS is only recommended for use
# by LLVM developers. If you want to build LLVM
# as a shared library, you should use the
# LLVM_BUILD_LLVM_DYLIB option
CMAKE_ARGS += -DBUILD_SHARED_LIBS=OFF

# Disable third-party benchmarks and unittest
# as not-included in build and fails
CMAKE_ARGS += -DLLVM_INCLUDE_BENCHMARKS=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_TESTS=OFF

# [intel-opencl-clang-140]
BUILD_DEPENDS += cross/intel-opencl-clang-140.src
CMAKE_ARGS += -DAPPLY_PATCHES='OFF'

# IGC specific
CMAKE_ARGS += -DIGC_OPTION__ARCHITECTURE_TARGET='Linux64'
CMAKE_ARGS += -DIGC_OPTION__ARCHITECTURE_HOST='Linux64'
CMAKE_ARGS += -DINSTALL_GENX_IR='ON'

# [intel-vc-intrinsics]
BUILD_DEPENDS += cross/intel-vc-intrinsics.src
# Leaving source directory in auto-configure mode du to CMake Warning:
#     Manually-specified variables were not used by the project: IGC_OPTION__VC_INTRINSICS_SOURCES_DIR
CMAKE_ARGS += -DIGC_OPTION__VC_INTRINSICS_MODE='Source'
#CMAKE_ARGS += -DIGC_OPTION__VC_INTRINSICS_SOURCES_DIR=$(WORK_DIR)/vc-intrinsics

# [Khronos-SPIRV-Headers]
BUILD_DEPENDS += cross/Khronos-SPIRV-Headers
CMAKE_ARGS += -DIGC_OPTION__USE_PREINSTALLED_SPIRV_HEADERS='ON'
CMAKE_ARGS += -DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR:PATH=$(WORK_DIR)/SPIRV-Headers

# [Khronos-SPIRV-LLVM-Translator -> llvm-spirv]
BUILD_DEPENDS += cross/Khronos-SPIRV-LLVM-Translator-140.src
CMAKE_ARGS += -DIGC_OPTION__LINK_KHRONOS_SPIRV_TRANSLATOR='ON'
# Leave in auto-configure as otherwise fails
#CMAKE_ARGS += -DIGC_OPTION__SPIRV_TRANSLATOR_MODE='Source'
#CMAKE_ARGS += -DIGC_OPTION__SPIRV_TRANSLATOR_SOURCE_DIR=$(WORK_DIR)/SPIRV-LLVM-Translator
# Fixes IGC/VectorCompiler/lib/Driver/SPIRVWrapper.cpp
#       fatal error: LLVMSPIRVLib.h: No such file or directory
# Further, have a look below at 'igc_intree_copy_llvm-spirv_include'
# for both opencl-clang and llvm-spirv (SPIRV-LLVM-Translator)
ADDITIONAL_CXXFLAGS += -I$(WORK_DIR)/SPIRV-LLVM-Translator/include

# [Khronos-SPIRV-Tools]
# Cannot be built in-tree:
#     SPIRV-Tools requires C++17 or later, but is configured for C++14
DEPENDS += cross/Khronos-SPIRV-Tools
CMAKE_ARGS += -DIGC_OPTION__SPIRV_TOOLS_MODE='Prebuilds'
#CMAKE_ARGS += -DIGC_OPTION__SPIRV_TOOLS_MODE='Source'
#CMAKE_ARGS += -DIGC_OPTION__SPIRV_TOOLS_SOURCE_DIR=$(WORK_DIR)/SPIRV-Tools

# [llvm]
BUILD_DEPENDS += cross/llvm-project-140.src
CMAKE_ARGS += -DIGC_OPTION__LLVM_MODE='Source'
CMAKE_ARGS += -DIGC_OPTION__LLVM_STOCK_SOURCES=ON
CMAKE_ARGS += -DIGC_OPTION__LLVM_SOURCES_DIR=$(WORK_DIR)/llvm-project
CMAKE_ARGS += -DIGC_OPTION__LLVM_PREFERRED_VERSION='$(IGC_LLVM_VER)'

# [llvm-clang]
CMAKE_ARGS += -DIGC_OPTION__CLANG_MODE='Source'
# Has no effect when using llvm-project sources
#CMAKE_ARGS += -DIGC_OPTION__CLANG_SOURCES_DIR:PATH=$(WORK_DIR)/llvm-project/clang
CMAKE_ARGS += -DCCLANG_FROM_SYSTEM='OFF'

# [llvm-lld]
CMAKE_ARGS += -DIGC_OPTION__LLD_MODE='Source'
# Has no effect when using llvm-project sources
#CMAKE_ARGS += -DIGC_OPTION__lld_SOURCES_DIR:PATH=$(WORK_DIR)/llvm-project/lld

# [llvm-libunwind]
# Required to copy libunwind/include/mach-o/compact_unwind_encoding.h
CMAKE_ARGS += -DDEFAULT_IGC_LLVM_SOURCES_DIR=$(WORK_DIR)/llvm-project

# Fails to access in NATIVE/bin/llvm-tblgen possibly due to parallel compiling
BUILD_DEPENDS += native/llvm-14.0
CMAKE_ARGS += -DLLVM_TABLEGEN=$(abspath $(PWD)/../../native/llvm-14.0/work-native/install/usr/local/bin/llvm-tblgen)
CMAKE_ARGS += -DCLANG_TABLEGEN=$(abspath $(PWD)/../../native/llvm-14.0/work-native/install/usr/local/bin/clang-tblgen)

include ../../mk/spksrc.cross-cmake.mk

# Requires access to:
#   CMCLTranslatorTool (during build time): IGC/Release/CMCLTranslatorTool
#   llvm-tblgen, clang-tool (symlink -> clang-14), llvm-link, opt: native/llvm-14.0
ENV += PATH=$(CMAKE_BUILD_DIR)/IGC/Release:$(abspath $(PWD)/../../native/llvm-14.0/work-native/install/usr/local/bin):$$PATH

# Associate external projects to LLVM build, this replaces (and cannot be combined):
#   -DLLVM_EXTERNAL_PROJECTS='llvm-spirv;opencl-clang'
#   -DLLVM_EXTERNAL_LLVM_SPIRV_SOURCE_DIR=$(WORK_DIR)/SPIRV-LLVM-Translator
#   -DLLVM_EXTERNAL_OPENCL_CLANG_SOURCE_DIR=$(WORK_DIR)/opencl-clang
# Note that vc-intrinsics is handled thru IGC, and not LLVM such as:
#   -DLLVM_EXTERNAL_PROJECTS='llvm-spirv;opencl-clang;vc-intrinsics'
#   -DLLVM_EXTERNAL_VC_INTRINSICS_SOURCE_DIR=$(WORK_DIR)/vc-intrinsics
igc_link_external_project:
	@cd $(WORK_DIR)/llvm-project/llvm/projects && ln -sf ../../../opencl-clang opencl-clang
	@cd $(WORK_DIR)/llvm-project/llvm/projects && ln -sf ../../../SPIRV-LLVM-Translator llvm-spirv

# When built in-tree intel-opencl-clang thru IGC it can't find llvm-spirv headers
# Similarly for itself which can find the actual include directory
# Further, using the following doesn't work for these two in particular:
#     ADDITIONAL_CXXFLAGS += -I$(WORK_DIR)/SPIRV-LLVM-Translator/include
igc_intree_copy_llvm-spirv_include: igc_link_external_project
	@cp $(WORK_DIR)/SPIRV-LLVM-Translator/include/* $(WORK_DIR)/opencl-clang/.
	@cp $(WORK_DIR)/SPIRV-LLVM-Translator/include/* $(WORK_DIR)/SPIRV-LLVM-Translator/lib/SPIRV/.

igc_post_extract_target: igc_intree_copy_llvm-spirv_include
	@cd $(WORK_DIR) && ln -sf $(PKG_DIR) $(PKG_NAME)
	@cd $(WORK_DIR) && ln -sf $(PKG_NAME) igc
