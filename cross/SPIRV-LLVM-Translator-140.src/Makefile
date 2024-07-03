PKG_NAME = SPIRV-LLVM-Translator
PKG_LLVM_MAJ = 14
PKG_VERS = $(PKG_LLVM_MAJ)0
PKG_GIT_BRANCH = llvm_release_$(PKG_VERS)
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_GIT_BRANCH).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive
PKG_DIR = $(PKG_NAME)-$(PKG_GIT_BRANCH)

HOMEPAGE = https://github.com/KhronosGroup/SPIRV-LLVM-Translator
COMMENT = Library and tool for translation between LLVM IR and SPIR-V.
LICENSE = LLVM Release License

POST_EXTRACT_TARGET = llvm_post_extract_target
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = nop

include ../../mk/spksrc.cross-cmake.mk

.PHONY: llvm_post_extract_target
llvm_post_extract_target:
	@cd $(WORK_DIR) && ln -s $(PKG_DIR) $(PKG_NAME)
