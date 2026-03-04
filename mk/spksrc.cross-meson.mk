# Build Meson programs
#
# This makefile extends spksrc.cross-cc.mk with Meson-specific functionality
#
# prerequisites:
# - cross/module depends on meson + ninja
#

# Configure the included makefiles
URLS          = $(PKG_DIST_SITE)/$(PKG_DIST_NAME)
NAME          = $(PKG_NAME)
COOKIE_PREFIX = $(PKG_NAME)-
ifneq ($(PKG_DIST_FILE),)
LOCAL_FILE    = $(PKG_DIST_FILE)
else
LOCAL_FILE    = $(PKG_DIST_NAME)
endif
DIST_FILE     = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT      = $(PKG_EXT)

ifneq ($(ARCH),)
ARCH_SUFFIX = -$(ARCH)-$(TCVERSION)
ifneq ($(ARCH),noarch)
TC = syno$(ARCH_SUFFIX)
endif
endif

# Common directories (must be set after ARCH_SUFFIX)
include ../../mk/spksrc.common/directories.mk

# Common makefiles
include ../../mk/spksrc.common.mk

###

# meson specific configurations
include ../../mk/spksrc.cross/env-meson.mk

# meson cross-file usage definition
include ../../mk/spksrc.cross/meson-crossfile.mk

# configure using meson
ifeq ($(strip $(CONFIGURE_TARGET)),)
CONFIGURE_TARGET = meson_configure_target
endif

# call-up ninja build process
include ../../mk/spksrc.build/ninja.mk

###

.PHONY: meson_configure_target
meson_configure_target: meson_generate_crossfile
	@$(MSG) - Meson configure
	@$(MSG)    - Dependencies = $(DEPENDS)
	@$(MSG)    - Build path = $(MESON_BUILD_DIR)
	@$(MSG)    - Configure ARGS = $(CONFIGURE_ARGS)
	@$(MSG)    - Install prefix = $(INSTALL_PREFIX)
	@$(MSG) meson setup $(MESON_BASE_DIR) $(MESON_BUILD_DIR) -Dprefix=$(INSTALL_PREFIX) $(CONFIGURE_ARGS)
	$(RUN) meson setup $(MESON_BASE_DIR) $(MESON_BUILD_DIR) -Dprefix=$(INSTALL_PREFIX) $(CONFIGURE_ARGS)

###

# Include base cross-cc makefile for common functionality
include ../../mk/spksrc.cross-cc.mk
