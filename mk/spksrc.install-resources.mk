# Install arch independent resources
#
# This makefile extends spksrc.cross-cc.mk but skips configure and compile steps
#
# packages using this have to:
# - implement a custom INSTALL_TARGET to copy the required files to the 
#   target location under $(STAGING_INSTALL_PREFIX)
# - create a PLIST file to include the target file(s)/folder(s)

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
include ../../mk/spksrc.directories.mk

# Common makefiles
include ../../mk/spksrc.common.mk

#####

ifneq ($(REQUIRE_KERNEL),)
  @$(error install-resources cannot be used when REQUIRE_KERNEL is set)
endif

# Skip configure and compile steps - go directly from patch to install
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop

# Note: INSTALL_TARGET must be defined by the package using this makefile

#####

# Include base cross-cc makefile for common functionality
include ../../mk/spksrc.cross-cc.mk

INSTALL_RESOURCES_INFO = $(WORK_DIR)/install-resources-$(PKG_NAME).info
INSTALL_RESOURCES_DEST ?= share/$(PKG_NAME)
# Source used for the default copy helper (normally the patched
# $(WORK_DIR)/$(PKG_DIR) tree).
INSTALL_RESOURCES_COPY_SRC ?= $(WORK_DIR)/$(PKG_DIR)
# Location recorded for downstream packages to merge. Default to the staging
# install output so consumers always get the post-install (i.e. patched)
# payload.
INSTALL_RESOURCES_STAGE_SRC ?= $(STAGING_INSTALL_PREFIX)/$(INSTALL_RESOURCES_DEST)

post_install_target: install_resources_info

.PHONY: install_resources_info
install_resources_info:
	@$(MSG) "Recording install-resources mapping for $(PKG_NAME)"
	@mkdir -p $(WORK_DIR)
	@echo "$(INSTALL_RESOURCES_STAGE_SRC)|$(INSTALL_RESOURCES_DEST)" > $(INSTALL_RESOURCES_INFO)

.PHONY: cat_INSTALL_RESOURCES
cat_INSTALL_RESOURCES:
	@if [ -f $(INSTALL_RESOURCES_INFO) ]; then cat $(INSTALL_RESOURCES_INFO); fi

# Default to copying the patched tree into the staging install prefix unless the
# package provides its own INSTALL_TARGET.
ifeq ($(strip $(INSTALL_TARGET)),)
INSTALL_TARGET = install_resources_copy
endif

install_resources_copy: pre_install_target
	@$(MSG) "Install resources copy for $(PKG_NAME)"
	$(RUN) rm -rf $(INSTALL_RESOURCES_STAGE_SRC)
	$(RUN) mkdir -p $(INSTALL_RESOURCES_STAGE_SRC)
	$(RUN) tar -cf - -C $(INSTALL_RESOURCES_COPY_SRC) . | tar -xf - -C $(INSTALL_RESOURCES_STAGE_SRC)
