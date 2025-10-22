# include this file to install native package without building from source
# adjusted for native packages based on spksrc.install-resources.mk
#
# native packages using this have to:
# - implement a custom INSTALL_TARGET to copy the required files to the 
#   target location under $(STAGING_INSTALL_PREFIX)

# Package dependent
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

ifneq ($(REQUIRE_KERNEL),)
  @$(error native-install cannot be used when REQUIRE_KERNEL is set)
endif

#####

# native-install specific: skip configure and compile steps
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop

# INSTALL_TARGET must be provided by the including makefile

#####

ifeq ($(strip $(PLIST_TRANSFORM)),)
PLIST_TRANSFORM= cat
endif

#####

# Include base native-cc makefile for common functionality
include ../../mk/spksrc.native-cc.mk
