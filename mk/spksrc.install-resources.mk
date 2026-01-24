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
