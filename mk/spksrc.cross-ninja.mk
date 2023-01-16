# Build CMake programs
#
# prerequisites:
# - cross/module depends on meson + ninja
#

# Force path to pkg-config for cross-building
ENV += PKG_CONFIG=/usr/bin/pkg-config

# Set default build directory
ifeq ($(strip $(NINJA_BUILD_DIR)),)
ifeq ($(strip $(CMAKE_USE_NINJA)),1)
NINJA_BUILD_DIR = $(CMAKE_BUILD_DIR)
else
NINJA_BUILD_DIR = $(MESON_BUILD_DIR)
endif
endif

# set default use destdir
ifeq ($(strip $(NINJA_USE_DESTDIR)),)
ifneq ($(strip $(CMAKE_USE_DESTDIR)),)
NINJA_USE_DESTDIR = $(CMAKE_USE_DESTDIR)
else
NINJA_USE_DESTDIR = 1
endif
endif

# set default destdir directory
ifeq ($(strip $(NINJA_DESTDIR)),)
ifeq ($(strip $(CMAKE_USE_NINJA)),1)
NINJA_DESTDIR = $(CMAKE_DESTDIR)
else
NINJA_DESTDIR = $(INSTALL_DIR)
endif
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
	@$(MSG)    - Ninja build path = $(WORK_DIR)/$(PKG_DIR)/$(NINJA_BUILD_DIR)
ifeq ($(strip $(CMAKE_USE_NINJA)),1)
	@$(MSG)    - Use NASM = $(CMAKE_USE_NASM)
endif
	cd $(WORK_DIR)/$(PKG_DIR) && env $(ENV) ninja -C $(NINJA_BUILD_DIR)

.PHONY: ninja_install_target

# default ninja install:
ninja_install_target:
	@$(MSG) - Ninja install
	@$(MSG)    - Ninja installation path = $(NINJA_DESTDIR)
	@$(MSG)    - Ninja use DESTDIR = $(NINJA_USE_DESTDIR)
ifeq ($(strip $(NINJA_USE_DESTDIR)),0)
	cd $(WORK_DIR)/$(PKG_DIR) && env $(ENV) $(PSTAT_TIME) ninja -j $(NCPUS) -C $(NINJA_BUILD_DIR) install
else
	cd $(WORK_DIR)/$(PKG_DIR) && env $(ENV) DESTDIR=$(NINJA_DESTDIR) $(PSTAT_TIME) ninja -j $(NCPUS) -C $(NINJA_BUILD_DIR) install
endif
