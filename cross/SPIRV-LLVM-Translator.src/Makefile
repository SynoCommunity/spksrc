PKG_NAME = SPIRV-LLVM-Translator
PKG_VERS = 18.1.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

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
