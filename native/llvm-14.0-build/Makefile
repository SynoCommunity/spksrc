PKG_NAME = llvm
PKG_VERS = 14.0.6

# REMARKS:
#
# This Makefile is to build a native llvm, clang, lld, along with SPIRV/OpenCL toolset.
# It also has one additional target to build the archive (make build-archive)
#
# Since it takes a huge amount of resources to build we are hosting ouput on
#     https://github.com/SynoCommunity/spksrc/releases/tag/native%2Fllvm
# And later referring to it using DEPENDS = native/llvm-14.0
#
# Usage of native LLVM tools and librairies is needed in order to avoid circular
# dependencies when building LLVM SPIRV/OpenCL toolset. Regular prebuilt packages
# do not contain these binaries and libraries must exactly match to avoid API issues.
#
#   binaries: clang-tblgen, llvm-tblgen, llvm-spirv
#   libraries:
#      libLLVM-14.so             <-- for built-time IGC 'CMCLTranslatorTool', 'elf_packager', 'vcb'
#      libLLVMGenXIntrinsics.so  <-- for built-time IGC 'CMCLTranslatorTool', 'vcb'
#      libLLVMSPIRVLib.so.14     <-- for built-time IGC 'vcb'

HOMEPAGE = https://llvm.org/
COMMENT = The LLVM Project is a collection of modular and reusable compiler and toolchain technologies.
LICENSE = Apache 2.0 with LLVM exceptions

DOWNLOAD_TARGET = nop
CHECKSUM_TARGET = nop
EXTRACT_TARGET = nop
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = nop

# -----------------------------------------------------------------------------
# Dependencies
# -----------------------------------------------------------------------------
NATIVE_DEPENDS += native/llvm-140
NATIVE_DEPENDS += native/Khronos-SPIRV-LLVM-Translator-140
NATIVE_DEPENDS += native/intel-vc-intrinsics
NATIVE_DEPENDS += native/intel-opencl-clang-140

# -----------------------------------------------------------------------------
# Include the common native-cmake rules
# -----------------------------------------------------------------------------
include ../../mk/spksrc.native-cmake.mk

# -----------------------------------------------------------------------------
# Recipe to generate an archive of installed directories
# -----------------------------------------------------------------------------
.PHONY: build-archive
build-archive:
	@$(MSG) "Build archive of install folder"
ifeq ($(wildcard work-native/install/usr/local/bin/*),)
	$(error "Installation not found. Please call make first.")
endif
	cd work-native && tar -cJf ../native-$(PKG_NAME)-$(PKG_VERS).txz ./install/*
