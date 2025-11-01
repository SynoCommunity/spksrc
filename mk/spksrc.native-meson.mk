# Build native Meson programs
#
# This makefile extends spksrc.native-cc.mk with Meson-specific functionality
#
# prerequisites:
# - native/module depends on meson + ninja
#

# Package dependent (same as native-cc.mk)
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

# Setup common directories
include ../../mk/spksrc.directories.mk

# Common makefiles
include ../../mk/spksrc.common.mk

#####

# configure using meson
ifeq ($(strip $(CONFIGURE_TARGET)),)
CONFIGURE_TARGET = meson_configure_target
endif

# Load native environment before meson-specific configs
include ../../mk/spksrc.native-env.mk

# meson specific configurations
include ../../mk/spksrc.native-meson-env.mk

# call-up ninja build process
include ../../mk/spksrc.ninja.mk

#####

# Meson specific targets
.PHONY: meson_configure_target

# default meson configure:
meson_configure_target:
	@$(MSG) - Meson configure
	@$(MSG)    - Dependencies = $(DEPENDS)
	@$(MSG)    - Build path = $(MESON_BUILD_DIR)
	@$(MSG)    - Configure ARGS = $(CONFIGURE_ARGS)
	@$(MSG)    - Install prefix = $(INSTALL_PREFIX)
	cd $(WORK_DIR)/$(PKG_DIR) && env $(ENV) meson $(MESON_BUILD_DIR) -Dprefix=$(INSTALL_PREFIX) $(CONFIGURE_ARGS)

#####

# Include base native-cc makefile for common functionality
include ../../mk/spksrc.native-cc.mk
