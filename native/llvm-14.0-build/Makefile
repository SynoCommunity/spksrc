PKG_NAME = llvm
PKG_LLVM_MAJ = 14
PKG_VERS = 14.0.5
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags
PKG_DIST_FILE = SPIRV-LLVM-Translator-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-project-$(PKG_VERS).src

# REMARKS:
# Since it takes a huge amount of resources to build this, we started to host the
# output on https://github.com/SynoCommunity/spksrc/releases/tag/native%2Fllvm
#
# This Makefile is to build the native llvm
# and has one additional target to build the archive (make build-archive)
#
# The main reason to build llvm from source is, that other prebuilt packages
# do not contain mandatory binaries to build cross/llvm-14.0.
#
#   Native binaries: clang-tblgen, llvm-tblgen, llvm-spirv

HOMEPAGE = https://github.com/KhronosGroup/SPIRV-LLVM-Translator
COMMENT  = Tool and library for translation between LLVM IR and SPIR-V
LICENSE  = Apache-2.0 with LLVM-exception

NATIVE_DEPENDS  = cross/llvm-project-140.src
NATIVE_DEPENDS += native/Khronos-SPIRV-Headers
NATIVE_DEPENDS += native/Khronos-SPIRV-Tools

POST_EXTRACT_TARGET = llvm_post_extract_target
POST_INSTALL_TARGET = llvm_post_install_target

# Using various LLVM project sources needs a top-level master directory
CMAKE_BUILD_DIR = $(WORK_DIR)/llvm.build
CMAKE_SOURCE_DIR = $(WORK_DIR)/llvm-project/llvm

CMAKE_ARGS += -DLLVM_TARGETS_TO_BUILD=X86
CMAKE_ARGS += -DCMAKE_BUILD_TYPE=MinSizeRel
CMAKE_ARGS += -DLLVM_ENABLE_ASSERTIONS=ON
CMAKE_ARGS += -DLLVM_BUILD_LLVM_DYLIB=ON
CMAKE_ARGS += -DLLVM_LINK_LLVM_DYLIB=ON
CMAKE_ARGS += -DBUILD_SHARED_LIBS=OFF
CMAKE_ARGS += -DLLVM_EXTERNAL_PROJECTS='llvm-spirv'
CMAKE_ARGS += -DLLVM_ENABLE_PROJECTS='clang;lld'

# Points towards proper source and include dirs
CMAKE_ARGS += -DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=$(STAGING_INSTALL_PREFIX)
CMAKE_ARGS += -DLLVM_EXTERNAL_LLVM_SPIRV_SOURCE_DIR=$(WORK_DIR)/SPIRV-LLVM-Translator

# Install all build tools
CMAKE_ARGS += -DLLVM_INSTALL_UTILS=ON
CMAKE_ARGS += -DLLVM_BUILD_TOOLS=ON
CMAKE_ARGS += -DLLVM_INSTALL_TOOLCHAIN_ONLY=OFF

# Assertions are internal checks to help find bugs
CMAKE_ARGS += -DLLVM_ENABLE_ASSERTIONS=OFF

# BUILD_SHARED_LIBS is only recommended for use by LLVM developers
CMAKE_ARGS += -DBUILD_SHARED_LIBS=OFF

# Disable benchmarks and tests
CMAKE_ARGS += -DLLVM_INCLUDE_BENCHMARKS=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_TESTS=OFF
CMAKE_ARGS += -DLLVM_BUILD_TESTS=OFF
CMAKE_ARGS += -DLLVM_INCLUDE_GO_TESTS=OFF

# Disable lit testing framework (requires patch as well to fully disable)
CMAKE_ARGS += -DLLVM_INCLUDE_UTILS=OFF

# Reduce build warnings
CMAKE_ARGS += -DCMAKE_CXX_STANDARD=14
CMAKE_ARGS += -DCMAKE_CXX_EXTENSIONS=ON
NATIVE_CXXFLAGS  = -Wno-cast-function-type
NATIVE_CXXFLAGS += -Wno-dangling-pointer
NATIVE_CXXFLAGS += -Wno-free-nonheap-object
NATIVE_CXXFLAGS += -Wno-missing-template-keyword
NATIVE_CXXFLAGS += -Wno-uninitialized

include ../../mk/spksrc.native-cmake.mk

.PHONY: llvm_post_extract_target llvm_post_install_target build-archive

# Create symlink for LLVM to find the translator
llvm_post_extract_target:
	@cd $(WORK_DIR) && ln -sf SPIRV-LLVM-Translator-$(PKG_VERS) SPIRV-LLVM-Translator
	@cd $(WORK_DIR)/llvm-project/llvm/projects && ln -sf ../../../$(PKG_DIR) llvm-spirv

llvm_post_install_target:
	$(RUN) install -m 755 $(CMAKE_BUILD_DIR)/bin/clang-tblgen $(STAGING_INSTALL_PREFIX)/bin/clang-tblgen

build-archive:
	@$(MSG) "Build archive of install folder"
ifeq ($(wildcard work-native/install/usr/local/bin/*),)
	$(error "Installation not found. Please call make first.")
endif
	cd work-native && tar -czf ../native-$(PKG_NAME)-$(PKG_VERS).tar.gz ./install/*
