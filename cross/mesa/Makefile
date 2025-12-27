PKG_NAME = mesa
PKG_VERS = 23.3.6
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://archive.mesa3d.org
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/libdrm
DEPENDS += cross/libexpat
DEPENDS += cross/Khronos-glslang
DEPENDS += cross/Khronos-SPIRV-LLVM-Translator-140
DEPENDS += cross/zlib
NATIVE_DEPENDS += native/llvm-14.0-libclc

HOMEPAGE = https://mesa3d.org/
COMMENT  = Open source implementations of OpenGL, OpenGL ES, Vulkan, OpenCL, and more.
LICENSE  = MIT

# -----------------------------------------------------------------------------
# LLVM
# -----------------------------------------------------------------------------
PRE_CONFIGURE_TARGET = mesa_pre_configure

.PHONY: mesa_pre_configure
mesa_pre_configure:
	@echo "[binaries]" > $(WORK_DIR)/$(PKG_DIR)/mesa.meson
	@echo "llvm-config = '$(STAGING_INSTALL_PREFIX)/bin/llvm-config'" >> $(WORK_DIR)/$(PKG_DIR)/mesa.meson

CONFIGURE_ARGS = --cross-file=$(WORK_DIR)/$(PKG_DIR)/mesa.meson

# -----------------------------------------------------------------------------
# Default meson parameters
# -----------------------------------------------------------------------------
CONFIGURE_ARGS += -Dvulkan-drivers=intel
CONFIGURE_ARGS += -Dvulkan-icd-dir=etc/vulkan/icd.d
CONFIGURE_ARGS += -Dgallium-drivers=
CONFIGURE_ARGS += -Dmicrosoft-clc=disabled
CONFIGURE_ARGS += -Dllvm=enabled
CONFIGURE_ARGS += -Dshared-llvm=enabled
CONFIGURE_ARGS += -Dplatforms=
CONFIGURE_ARGS += -Dgbm=disabled
CONFIGURE_ARGS += -Dglx=disabled
CONFIGURE_ARGS += -Degl=disabled
CONFIGURE_ARGS += -Dgles1=disabled
CONFIGURE_ARGS += -Dgles2=disabled
CONFIGURE_ARGS += -Dopengl=false
CONFIGURE_ARGS += -Dlibunwind=disabled
CONFIGURE_ARGS += -Dvalgrind=disabled
CONFIGURE_ARGS += -Dbuild-tests=false
CONFIGURE_ARGS += -Dglvnd=false

include ../../mk/spksrc.cross-meson.mk
