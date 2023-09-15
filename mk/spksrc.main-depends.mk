# include this file for dummy modules that evaluate dependent packages only
#

# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

# Configure the included makefiles
NAME          = $(PKG_NAME)
COOKIE_PREFIX = $(PKG_NAME)-

ifneq ($(ARCH),)
ARCH_SUFFIX = -$(ARCH)-$(TCVERSION)
TC = syno$(ARCH_SUFFIX)
endif


#####

ifneq ($(REQUIRE_KERNEL),)
  @$(error main-depends cannot be used when REQUIRE_KERNEL is set)
endif

#####

# to check for supported archs and DSM versions
include ../../mk/spksrc.pre-check.mk

# for common env variables
include ../../mk/spksrc.cross-env.mk

# for dependency evaluation
include ../../mk/spksrc.depend.mk


install: depend
include ../../mk/spksrc.install.mk

plist: install
include ../../mk/spksrc.plist.mk

### Clean rules
smart-clean:
	rm -rf $(WORK_DIR)/$(PKG_DIR)
	rm -f $(WORK_DIR)/.$(COOKIE_PREFIX)*

clean:
	rm -rf work work-* build-*.log

all: install plist

### For make dependency-tree
include ../../mk/spksrc.dependency-tree.mk

.PHONY: all-archs
all-archs: $(addprefix arch-,$(AVAILABLE_TOOLCHAINS))

####

all-supported: SHELL:=/bin/bash
all-supported:
	@$(MSG) Pre-build native dependencies for parallel build
	@for depend in $$($(MAKE) dependency-list) ; \
	do \
	  if [ "$${depend%/*}" = "native" ]; then \
	    $(MSG) "Pre-processing $${depend}" ; \
	    $(MSG) "  env $(ENV) $(MAKE) -C ../../$$depend" ; \
	    env $(ENV) $(MAKE) -C ../../$$depend 2>&1 | tee --append build-$${depend%/*}-$${depend#*/}.log ; \
	    [ $${PIPESTATUS[0]} -eq 0 ] || false ; \
	  fi ; \
	done ; \
	$(MAKE) $(addprefix supported-arch-,$(SUPPORTED_ARCHS))

supported-arch-%:
	@$(MSG) BUILDING package for arch $* with SynoCommunity toolchain
	-@MAKEFLAGS= $(PSTAT_TIME) $(MAKE) arch-$* 2>&1 | tee --append build-$*.log

arch-%:
	@$(MSG) Building package for arch $*
	@MAKEFLAGS= $(MAKE) ARCH=$(basename $(subst -,.,$(basename $(subst .,,$*)))) TCVERSION=$(if $(findstring $*,$(basename $(subst -,.,$(basename $(subst .,,$*))))),$(DEFAULT_TC),$(notdir $(subst -,/,$*)))  2>&1 | tee --append build-$*.log

####
