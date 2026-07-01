
# Base definitions. Included explicitly (not relied upon via tests.mk) so the
# root targets and `make help` do not depend on the still-evolving tests.mk.
include mk/spksrc.common.mk

# Include framework self-test
include mk/spksrc.rules/tests.mk
include mk/spksrc.rules/dependency-tree.mk

AVAILABLE_TCS = $(notdir $(wildcard toolchain/syno-*))
AVAILABLE_ARCHS = $(notdir $(subst syno-,/,$(AVAILABLE_TCS)))
SUPPORTED_SPKS = $(sort $(patsubst spk/%/Makefile,%,$(wildcard spk/*/Makefile)))

##@ General

# help          : full grouped list of documented targets
# help-<topic>  : filter by section or target name, e.g. "make help-clean"
# Only targets carrying a "## description" are listed, so internal hook targets
# (pre_*, post_*, *_msg) never appear.
HELP_AWK = awk -v topic="$(HELP_TOPIC)" ' \
	  BEGIN { printf "\n\033[1mspksrc\033[0m - Synology package build system\n" } \
	  /^\#\#@/ { section = substr($$0, 5); next } \
	  /^[a-zA-Z0-9_%-]+:.*\#\#[^@]/ { \
	    name = $$0; sub(/:.*/, "", name); \
	    desc = $$0; sub(/.*\#\#[ \t]*/, "", desc); \
	    if (topic == "" || index(tolower(section " " name), tolower(topic))) { \
	      if (section != cur) { printf "\n\033[1m%s\033[0m\n", section; cur = section } \
	      printf "  \033[36m%-17s\033[0m %s\n", name, desc; matched++ \
	    } \
	  } \
	  END { \
	    if (matched == 0) { printf "\nNo target matches \"%s\".\n", topic } \
	    else if (topic == "") { \
	      printf "\n\033[1mPer-package (pattern) targets\033[0m\n"; \
	      printf "  \033[36m%-17s\033[0m %s\n", "<spk>", "build one SPK (e.g. make tvheadend)"; \
	      printf "  \033[36m%-17s\033[0m %s\n", "spk-<spk>-<arch>", "build one SPK for one arch (make spk-tvheadend-x64-7.1)"; \
	      printf "  \033[36m%-17s\033[0m %s\n", "native-<name>", "build one native tool (e.g. make native-cmake)"; \
	      printf "  \033[36m%-17s\033[0m %s\n", "toolchain-<arch>", "build one toolchain (make toolchain-x64-7.1)"; \
	      printf "  \033[36m%-17s\033[0m %s\n", "kernel-<arch>", "build one kernel module set" \
	    } \
	    printf "\nUse \033[36mmake help-<topic>\033[0m to filter (e.g. \033[36mmake help-clean\033[0m)\n\n" \
	  }' $(MAKEFILE_LIST)

.PHONY: help
help: HELP_TOPIC :=
help:  ## Show this help; use "make help-<topic>" to filter (e.g. help-clean)
	@$(HELP_AWK)

help-%: HELP_TOPIC = $*
help-%:
	@$(HELP_AWK)

##@ Build

ifneq ($(firstword $(MAKECMDGOALS)),test)
all: $(SUPPORTED_SPKS)  ## Build every supported SPK (long; usually build one <spk> instead)
endif

all-noarch:  ## Build every noarch (override ARCH) SPK
	@for spk in $(filter-out $(dir $(wildcard spk/*/BROKEN)),$(dir $(wildcard spk/*/Makefile))) ; \
	do \
	   grep -q "override ARCH" "$${spk}/Makefile" && $(MAKE) -C $${spk} ; \
	done

##@ Clean

ifneq ($(firstword $(MAKECMDGOALS)),test)
clean: $(addsuffix -clean,$(SUPPORTED_SPKS))  ## Clean all SPK, native and cross work dirs
clean: native-clean cross-clean
endif

dist-clean: clean  ## Clean everything, including kernel/toolchain/toolkit
dist-clean: kernel-clean toolchain-clean toolkit-clean

native-clean:  ## Clean all native/ work dirs
	@for native in $(dir $(wildcard native/*/Makefile)) ; \
	do \
	    $(MAKE) -C $${native} clean ; \
	done

toolchain-clean:  ## Clean all toolchain/ work dirs
	@for tc in $(dir $(wildcard toolchain/*/Makefile)) ; \
	do \
	    $(MAKE) -C $${tc} clean ; \
	done

toolkit-clean:  ## Clean all toolkit/ work dirs
	@for tk in $(dir $(wildcard toolkit/*/Makefile)) ; \
	do \
	    $(MAKE) -C $${tk} clean ; \
	done

kernel-clean:  ## Clean all kernel/ work dirs
	@for kernel in $(dir $(wildcard kernel/*/Makefile)) ; \
	do \
	    rm -rf $${kernel}/work* ; \
	done

cross-clean:  ## Clean all cross/ work dirs
	@for cross in $(dir $(wildcard cross/*/Makefile)) ; \
	do \
	    $(MAKE) -C $${cross} clean ; \
	done

spk-clean:  ## Clean all spk/ work dirs
	@for spk in $(filter-out $(dir $(wildcard spk/*/BROKEN)),$(dir $(wildcard spk/*/Makefile))) ; \
	do \
	    $(MAKE) -C $${spk} clean ; \
	done

%: spk/%/Makefile
	cd $(dir $^) && env $(MAKE)

native-%: native/%/Makefile
	cd $(dir $^) && env $(MAKE)

native-%-clean: native/%/Makefile
	cd $(dir $^) && env $(MAKE) clean

# define a template that instantiates a 'python3-avoton-6.1' -style target for
# every ($2) arch, every ($1) spk
define SPK_ARCH_template =
spk-$(1)-$(2): spk/$(1)/Makefile setup
	cd spk/$(1) && env $(MAKE) arch-$(2)
endef
$(foreach arch,$(AVAILABLE_ARCHS),$(foreach spk,$(SUPPORTED_SPKS),$(eval $(call SPK_ARCH_template,$(spk),$(arch)))))

##@ Prepare

prepare: downloads  ## Download sources and build all toolchains
	@for tc in $(dir $(wildcard toolchain/*/Makefile)) ; \
	do \
	    $(MAKE) -C $${tc} ; \
	done

downloads:  ## Download all cross/ package sources
	@for dl in $(dir $(wildcard cross/*/Makefile)) ; \
	do \
	    $(MAKE) -C $${tc} download ; \
	done

natives:  ## Build all native/ tools
	@for n in $(dir $(wildcard native/*/Makefile)) ; \
	do \
	    $(MAKE) -C $${n} ; \
	done

##@ Digests

native-digests:  ## Regenerate digests for all native/ packages
	@for n in $(dir $(wildcard native/*/Makefile)) ; \
	do \
	    $(MAKE) -C $${n} digests ; \
	done

toolchain-digests:  ## Regenerate digests for all toolchain/ packages
	@for tc in $(dir $(wildcard toolchain/*/Makefile)) ; \
	do \
	    $(MAKE) -C $${tc} digests ; \
	done

toolkit-digests:  ## Regenerate digests for all toolkit/ packages
	@for tk in $(dir $(wildcard toolkit/*/Makefile)) ; \
	do \
	    $(MAKE) -C $${tk} digests ; \
	done

kernel-digests:  ## Regenerate digests for all kernel/ packages
	@for kernel in $(dir $(wildcard kernel/*/Makefile)) ; \
	do \
	    $(MAKE) -C $${kernel} digests ; \
	done

cross-digests:  ## Regenerate digests for all cross/ packages
	@for cross in $(dir $(wildcard cross/*/Makefile)) ; \
	do \
	    $(MAKE) -C $${cross} digests ; \
	done

##@ Lint

jsonlint:
ifeq (,$(shell which jsonlint))
	$(error "jsonlint not found, install with: npm install -g jsonlint")
else
	find spk/ -not -path "*work*" -regextype posix-extended -regex '.*(\.json|install_uifile\w*|upgrade_uifile\w*|app/config)' -print -exec jsonlint -q -c {} \;
endif
lint: jsonlint  ## Validate all package JSON / wizard files

##@ Toolchain & kernel

.PHONY: toolchains kernel-modules
toolchains: $(addprefix toolchain-,$(AVAILABLE_ARCHS))  ## Build every available toolchain
kernel-modules: $(addprefix kernel-,$(AVAILABLE_ARCHS))  ## Build every available kernel

toolchain-%:
	-@cd toolchain/syno-$*/ && MAKEFLAGS= $(MAKE)

kernel-%:
	-@cd kernel/syno-$*/ && MAKEFLAGS= $(MAKE)

##@ Setup

setup: local.mk dsm-6.2.4 dsm-7.1  ## Create local.mk and set default DSM toolchains

local.mk:
	@echo "Creating local configuration \"local.mk\"..."
	@echo "PUBLISH_URL =" > $@
	@echo "PUBLISH_API_KEY =" >> $@
	@echo "DISTRIBUTOR =" >> $@
	@echo "DISTRIBUTOR_URL =" >> $@
	@echo "REPORT_URL =" >> $@
	@echo "DEFAULT_TC =" >> $@
	@echo "# Option to disable the use of github API to get the real name and url of the maintainer" >> $@
	@echo "# define it for local builds when you reach the API rate limit" >> $@
	@echo "DISABLE_GITHUB_MAINTAINER =" >> $@
	@echo "PSTAT = on" >> $@
	@echo "#PARALLEL_MAKE = max" >> $@

dsm-%: local.mk
	@echo "Setting default toolchain version to DSM-$*"
	@grep -q "^DEFAULT_TC.*=.*$*.*" local.mk || sed -i "/^DEFAULT_TC =/s/$$/ $*/" local.mk

setup-synocommunity: setup  ## Set up local.mk pointing at the SynoCommunity repository
	@sed -i -e "s|PUBLISH_URL\s*=.*|PUBLISH_URL = https://api.synocommunity.com|" \
		-e "s|DISTRIBUTOR\s*=.*|DISTRIBUTOR = SynoCommunity|" \
		-e "s|DISTRIBUTOR_URL\s*=.*|DISTRIBUTOR_URL = https://synocommunity.com|" \
		-e "s|REPORT_URL\s*=.*|REPORT_URL = https://github.com/SynoCommunity/spksrc/issues|" \
		local.mk
