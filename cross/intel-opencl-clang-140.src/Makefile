PKG_NAME = opencl-clang
PKG_LLVM_MAJ = 14
PKG_VERS = $(PKG_LLVM_MAJ)0
PKG_GIT_BRANCH = ocl-open-$(PKG_VERS)
PKG_EXT = tar.gz
PKG_DIST_SITE = https://github.com/intel/opencl-clang/archive

# ocl-open-140 branch is still receiving updates
# using latest git hash to ensure replicable builds
PKG_GIT_HASH = 470cf0018e1ef6fc92eda1356f5f31f7da452abc
PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_GIT_HASH)

# use below for direct ocl-open-140 branch
#PKG_DIST_NAME = $(PKG_GIT_BRANCH).$(PKG_EXT)
#PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
#PKG_DIR = $(PKG_NAME)-$(PKG_GIT_BRANCH)

HOMEPAGE = https://github.com/intel/opencl-clang
COMMENT  = opencl-clang is a thin wrapper library around clang. The library has OpenCL-oriented API and is capable to compile OpenCL C kernels to SPIR-V modules.
LICENSE  = Apache License v2.0 with LLVM Exceptions

POST_EXTRACT_TARGET = opencl-clang_post_extract_target
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = nop

include ../../mk/spksrc.cross-cmake.mk

opencl-clang_post_extract_target:
	@cd $(WORK_DIR) && ln -s $(PKG_DIR) $(PKG_NAME)
