# Build CMake programs
#
# prerequisites:
# - cross/module depends on meson + ninja
#

# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

# Use native cmake
DEPENDS += native/ninja
NINJA_PATH = $(WORK_DIR)/../../../native/ninja/work-native/install/usr/local/bin
ENV += PATH=$(NINJA_PATH):$$PATH

# Define build directory
BUILDDIR=builddir/

# Set other build options
CONFIGURE_ARGS += -Dbuildtype=release

# configure using cmake
ifeq ($(strip $(CONFIGURE_TARGET)),)
CONFIGURE_TARGET = meson_configure_target
endif

# compile
ifeq ($(strip $(COMPILE_TARGET)),)
COMPILE_TARGET = ninja_compile_target
endif

# install
ifeq ($(strip $(INSTALL_TARGET)),)
INSTALL_TARGET = ninja_install_target
endif

.PHONY: meson_configure_target

# default meson configure:
meson_configure_target:
	@$(MSG) - Meson configure
	@$(MSG)    - Dependencies = $(DEPENDS)
	@$(MSG)    - Build path = $(WORK_DIR)/$(PKG_DIR)/$(BUILDDIR)
	@$(MSG)    - Configure ARGS = $(CONFIGURE_ARGS)
	@$(MSG)    - Install prefix = $(STAGING_INSTALL_PREFIX)
	cd $(WORK_DIR)/$(PKG_DIR) && env $(ENV) meson builddir/ -Dprefix=$(STAGING_INSTALL_PREFIX) $(CONFIGURE_ARGS)

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
