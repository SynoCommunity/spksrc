###############################################################################
# spksrc.cross-go.mk
#
# Build go programs
#
# This makefile extends spksrc.cross-cc.mk with Go-specific functionality
#
# prerequisites:
# - cross/module needs no BUILD_DEPENDS for go: env-go.mk adds the native go it picks
# - MIN_GO_VERSION defaults to 1.24, which needs Linux 3.2; a module go 1.23 still builds
#   sets MIN_GO_VERSION = 1.23 to build for older kernels (ARMv5) too
# - module does not require kernel (REQUIRE_KERNEL)
#
# remarks:
# - Restriction for minimal DSM version is not supported (toolchains are not used for go builds)
# - CONFIGURE_TARGET is not supported/bypassed
#
###############################################################################

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


# Go 1.24 and later need Linux 3.2 (accept4 lost its fallback; ARM 2.6.32 lacks it). A module
# go 1.23 still builds sets MIN_GO_VERSION = 1.23, the go env-go.mk gives older kernels.
MIN_GO_VERSION ?= 1.24
GO_NEEDS_LINUX_3_2 = $(if $(filter 1.23 1.23.%,$(MIN_GO_VERSION)),,1)
GO_LINUX_3_2_FROM = 1.24
MIN_KERNEL_VERSION ?= $(if $(GO_NEEDS_LINUX_3_2),3.2)

# Common makefiles
include ../../mk/spksrc.common.mk

##### golang specific configurations
include ../../mk/spksrc.cross/env-go.mk

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

# Where the build is locked to the native go (GOTOOLCHAIN=local), a go.mod asking for more
# fails it: warn first, with what to change. Elsewhere go fetches the go that go.mod asks for.
GO_TOOLCHAIN_LOCAL = $(filter GOTOOLCHAIN=local,$(lastword $(filter GOTOOLCHAIN=%,$(ENV))))
configure_msg: go_mod_check
.PHONY: go_mod_check
go_mod_check:
	@d=$(or $(GO_SRC_DIR),$(WORK_DIR)/$(PKG_DIR)) ; \
	while [ ! -f "$$d/go.mod" ] && [ "$$d" != "$(WORK_DIR)" ] && [ "$$d" != "/" ] ; do d=$$(dirname "$$d") ; done ; \
	v=$$(sed -n 's/^go[[:space:]]\{1,\}\([0-9][0-9.]*\).*/\1/p' "$$d/go.mod" 2>/dev/null | head -1) ; \
	[ -n "$$v" ] || exit 0 ; \
	if [ -n "$(GO_TOOLCHAIN_LOCAL)" ] ; then \
	  n=$$(cd / && env $(ENV) go env GOVERSION | sed 's/^go//') ; \
	  if ! printf '%s\n' "$$v" "$$n" | sort -VC ; then \
	    echo "WARNING: $$d/go.mod asks for go $$v, this build is locked to go $$n (GOTOOLCHAIN=local):" ; \
	    echo "WARNING: $(if $(GO_NEEDS_LINUX_3_2),it needs a newer native go,it no longer builds for kernels older than 3.2: remove MIN_GO_VERSION = $(MIN_GO_VERSION))" ; \
	  fi ; \
	elif [ -n "$(GO_NEEDS_LINUX_3_2)" ] && ! printf '%s\n' $(GO_LINUX_3_2_FROM) "$$v" | sort -VC ; then \
	  echo "NOTE: $$d/go.mod asks for go $$v: MIN_GO_VERSION = 1.23 would also build it for kernels older than 3.2" ; \
	fi

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
