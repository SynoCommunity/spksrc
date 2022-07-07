# Build go programs
# 
# prerequisites:
# - cross/module depends on native/go only
# - module does not require kernel (REQUIRE_KERNEL)
# 
# remarks:
# - Restriction for minimal DSM version is not supported (toolchains are not used for go builds)
# - CONFIGURE_TARGET is not supported/bypassed
# - most content is taken from spksrc.cc.mk and modified for go build and install
# 

# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

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
TC = syno$(ARCH_SUFFIX)
endif

##### golang specific configurations
include ../../mk/spksrc.cross-go-env.mk

# avoid run of make configure
CONFIGURE_TARGET = nop


ifeq ($(strip $(COMPILE_TARGET)),)
ifneq ($(strip $(GO_SRC_DIR)),)
COMPILE_TARGET = go_build_target
endif
endif

# default go build:
go_build_target:
	@$(MSG) - Compile with go build
	cd $(GO_SRC_DIR) && env $(ENV) go build $(GO_BUILD_ARGS)


ifeq ($(strip $(INSTALL_TARGET)),)
ifneq ($(strip $(GO_BIN_DIR)),)
INSTALL_TARGET = go_install_target
endif
endif

# default go install:
go_install_target:
	@$(MSG) - Install go binaries
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(GO_BIN_DIR) $(STAGING_INSTALL_PREFIX)/bin/


#####

ifneq ($(REQUIRE_KERNEL),)
  @$(error go modules cannot build when REQUIRE_KERNEL is set)
endif

include ../../mk/spksrc.pre-check.mk

include ../../mk/spksrc.cross-env.mk

include ../../mk/spksrc.download.mk

include ../../mk/spksrc.depend.mk

checksum: download
include ../../mk/spksrc.checksum.mk

extract: checksum depend
include ../../mk/spksrc.extract.mk

patch: extract
include ../../mk/spksrc.patch.mk

configure: patch
include ../../mk/spksrc.configure.mk

compile: configure
include ../../mk/spksrc.compile.mk

install: compile
include ../../mk/spksrc.install.mk

plist: install
include ../../mk/spksrc.plist.mk


### Clean rules
smart-clean:
	rm -rf $(EXTRACT_PATH)/
	rm -f $(WORK_DIR)/.$(COOKIE_PREFIX)*

clean:
	rm -fr work work-*


all: install plist

### For make digests
include ../../mk/spksrc.generate-digests.mk

### For make dependency-tree
include ../../mk/spksrc.dependency-tree.mk

.PHONY: all-archs
all-archs: $(addprefix arch-,$(AVAILABLE_ARCHS))

####

arch-%:
	@$(MSG) Building package for arch $*
	@MAKEFLAGS= $(MAKE) ARCH=$(basename $(subst -,.,$(basename $(subst .,,$*)))) TCVERSION=$(if $(findstring $*,$(basename $(subst -,.,$(basename $(subst .,,$*))))),$(DEFAULT_TC),$(notdir $(subst -,/,$*))) 2>&1 | tee --append build-$*.log

####
