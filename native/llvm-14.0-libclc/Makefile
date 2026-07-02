PKG_NAME = libclc
PKG_LLVM_MAJ = 14
PKG_VERS = $(PKG_LLVM_MAJ).0.6
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).src.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/llvm/llvm-project/releases/download/llvmorg-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS).src

HOMEPAGE = https://libclc.llvm.org/
COMMENT  = Library requirements of the OpenCL C programming language
LICENSE  = BSD/MIT dual licensed

POST_INSTALL_TARGET = libclc_create_pkgconfig

# -----------------------------------------------------------------------------
# Dependencies
# -----------------------------------------------------------------------------
DEPENDS = native/llvm-14.0

# -----------------------------------------------------------------------------
# Directories
# -----------------------------------------------------------------------------
LLVM_BIN_DIR = $(abspath $(PWD)/../../$(DEPENDS)/work-native/install/usr/local/bin)

# Add native LLVM tools to PATH
ENV += PATH=$(LLVM_BIN_DIR):$$PATH

# -----------------------------------------------------------------------------
# CMake arguments
# -----------------------------------------------------------------------------
CMAKE_ARGS += -DLIBCLC_TARGETS_TO_BUILD="spirv-mesa3d-;spirv64-mesa3d-"

CMAKE_ARGS += -DLLVM_CONFIG=$(LLVM_BIN_DIR)/llvm-config
CMAKE_ARGS += -DLLVM_CLANG=$(LLVM_BIN_DIR)/clang
CMAKE_ARGS += -DLLVM_LINK=$(LLVM_BIN_DIR)/llvm-link
CMAKE_ARGS += -DLLVM_AS=$(LLVM_BIN_DIR)/llvm-as
CMAKE_ARGS += -DLLVM_SPIRV=$(LLVM_BIN_DIR)/llvm-spirv

# -----------------------------------------------------------------------------
# Include the common cross-cmake rules
# -----------------------------------------------------------------------------
include ../../mk/spksrc.native-cmake.mk

.PHONY: libclc_create_pkgconfig
libclc_create_pkgconfig:
	@echo "Creating libclc.pc file"
	@mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig
	@( \
		echo "prefix=$(INSTALL_PREFIX)"; \
		echo "includedir=\$${prefix}/include"; \
		echo "datadir=\$${prefix}/share"; \
		echo ""; \
		echo "Name: libclc"; \
		echo "Description: Library requirements for OpenCL C"; \
		echo "Version: $(PKG_VERS)"; \
		echo "Cflags: -I\$${includedir}"; \
	) > $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/libclc.pc
