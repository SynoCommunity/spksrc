# Build go programs
#
# This makefile extends spksrc.cross-cc.mk with Go-specific functionality
# 
# prerequisites:
# - cross/module depends on native/go or native/go_1.23 only
# - module does not require kernel (REQUIRE_KERNEL)
# 
# remarks:
# - Restriction for minimal DSM version is not supported (toolchains are not used for go builds)
# - CONFIGURE_TARGET is not supported/bypassed
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
include ../../mk/spksrc.directories.mk

# Common makefiles
include ../../mk/spksrc.common.mk

##### golang specific configurations
include ../../mk/spksrc.cross-go-env.mk

# avoid run of make configure
ifeq ($(strip $(CONFIGURE_TARGET)),)
CONFIGURE_TARGET = nop
endif

ifeq ($(strip $(COMPILE_TARGET)),)
ifneq ($(strip $(GO_SRC_DIR)),)
COMPILE_TARGET = go_build_target
endif
endif

ifeq ($(strip $(INSTALL_TARGET)),)
ifneq ($(strip $(GO_BIN_DIR)),)
INSTALL_TARGET = go_install_target
endif
endif

#####

ifneq ($(REQUIRE_KERNEL),)
  @$(error go modules cannot build when REQUIRE_KERNEL is set)
endif

###

# Go specific targets
.PHONY: go_build_target

# default go build:
go_build_target:
	@$(MSG) - Compile with go build
	@cd $(GO_SRC_DIR) && env $(ENV) go build $(GO_BUILD_ARGS)

.PHONY: go_install_target

# default go install:
go_install_target:
	@$(MSG) - Install go binaries
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(GO_BIN_DIR) $(STAGING_INSTALL_PREFIX)/bin/

###

# Include base cross-cc makefile for common functionality
include ../../mk/spksrc.cross-cc.mk
