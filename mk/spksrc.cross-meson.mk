# Build CMake programs
#
# prerequisites:
# - cross/module depends on meson + ninja
#

# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

# meson specific configurations
include ../../mk/spksrc.cross-meson-env.mk

# configure using meson
ifeq ($(strip $(CONFIGURE_TARGET)),)
CONFIGURE_TARGET = meson_configure_target
endif

.PHONY: meson_configure_target

# default meson configure:
meson_configure_target:
	@$(MSG) - Meson configure
	@$(MSG)    - Dependencies = $(DEPENDS)
	@$(MSG)    - Build path = $(WORK_DIR)/$(PKG_DIR)/$(MESON_BUILD_DIR)
	@$(MSG)    - Configure ARGS = $(CONFIGURE_ARGS)
	@$(MSG)    - Install prefix = $(INSTALL_PREFIX)
	cd $(WORK_DIR)/$(PKG_DIR) && env $(ENV) meson $(MESON_BUILD_DIR) -Dprefix=$(INSTALL_PREFIX) $(CONFIGURE_ARGS)

# call-up ninja build process
include ../../mk/spksrc.cross-ninja.mk

# call-up regular build process
include ../../mk/spksrc.cross-cc.mk
