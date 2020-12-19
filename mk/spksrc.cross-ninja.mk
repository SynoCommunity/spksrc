# Build CMake programs
#
# prerequisites:
# - cross/module depends on meson + ninja
#

# Force path to pkg-config for cross-building
ENV += PKG_CONFIG=/usr/bin/pkg-config

# compile
ifeq ($(strip $(COMPILE_TARGET)),)
COMPILE_TARGET = ninja_compile_target
endif

# install
ifeq ($(strip $(INSTALL_TARGET)),)
INSTALL_TARGET = ninja_install_target
endif

.PHONY: ninja_compile_target

# default ninja compile:
ninja_compile_target:
	@$(MSG) - Ninja compile
	@$(MSG)    - Build path = $(WORK_DIR)/$(PKG_DIR)/$(BUILDDIR)
	cd $(WORK_DIR)/$(PKG_DIR) && env $(ENV) ninja -C builddir/

.PHONY: ninja_install_target

# default ninja install:
ninja_install_target:
	@$(MSG) - Ninja install
	@$(MSG)    - Build path = $(WORK_DIR)/$(PKG_DIR)/$(BUILDDIR)
	cd $(WORK_DIR)/$(PKG_DIR) && env $(ENV) ninja -C builddir/ install

# call-up regular build process
include ../../mk/spksrc.cross-cc.mk
