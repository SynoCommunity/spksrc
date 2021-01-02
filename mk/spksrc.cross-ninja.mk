# Build CMake programs
#
# prerequisites:
# - cross/module depends on meson + ninja
#

# Force path to pkg-config for cross-building
ENV += PKG_CONFIG=/usr/bin/pkg-config

# Set default build directory
ifeq ($(strip $(NINJA_BUILD_DIR)),)
NINJA_BUILD_DIR = $(MESON_BUILD_DIR)
endif

ifeq ($(strip $(NINJA_DESTDIR)),)
NINJA_DESTDIR = $(INSTALL_DIR)
endif

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
	@$(MSG)    - Build path = $(WORK_DIR)/$(PKG_DIR)/$(NINJA_BUILD_DIR)
	cd $(WORK_DIR)/$(PKG_DIR) && env $(ENV) ninja -C $(NINJA_BUILD_DIR)

.PHONY: ninja_install_target

# default ninja install:
ninja_install_target:
	@$(MSG) - Ninja install
	@$(MSG)    - Build path = $(WORK_DIR)/$(PKG_DIR)/$(NINJA_BUILD_DIR)
	@$(MSG)    - Installation path = $(NINJA_DESTDIR)
	cd $(WORK_DIR)/$(PKG_DIR) && env $(ENV) DESTDIR=$(NINJA_DESTDIR) ninja -C $(NINJA_BUILD_DIR) install
