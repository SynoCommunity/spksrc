PKG_NAME = SPIRV-LLVM-Translator
PKG_LLVM_MAJ = 14
PKG_VERS = $(PKG_LLVM_MAJ)0
PKG_GIT_BRANCH = llvm_release_$(PKG_VERS)
PKG_EXT = tar.gz
PKG_DIST_SITE = https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive

# llvm_release_140 branch is still receiving updates
# using latest gis hash to ensure replicable builds
PKG_GIT_HASH = f23845001443049a9f1b0472b9a6f491aee46e3e
PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_GIT_HASH)

# use below for direct llvm_release_140 branch
#PKG_DIST_NAME = $(PKG_GIT_BRANCH).$(PKG_EXT)
#PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
#PKG_DIR = $(PKG_NAME)-$(PKG_GIT_BRANCH)

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
