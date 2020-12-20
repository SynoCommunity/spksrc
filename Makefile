
AVAILABLE_TCS = $(notdir $(wildcard toolchain/syno-*))
AVAILABLE_ARCHS = $(notdir $(subst syno-,/,$(AVAILABLE_TCS)))
SUPPORTED_SPKS = $(sort $(patsubst spk/%/Makefile,%,$(wildcard spk/*/Makefile)))


all: $(SUPPORTED_SPKS)

all-noarch:
	@for spk in $(sort $(dir $(wildcard spk/*/Makefile))) ; \
	do \
	   grep -q "override ARCH" "$${spk}/Makefile" && $(MAKE) -C $${spk} ; \
	done


clean: $(addsuffix -clean,$(SUPPORTED_SPKS))
clean: native-clean cross-clean

dist-clean: clean
dist-clean: kernel-clean toolchain-clean toolkit-clean

native-clean:
	@for native in $(dir $(wildcard native/*/Makefile)) ; \
	do \
	    $(MAKE) -C $${native} clean ; \
	done

toolchain-clean:
	@for tc in $(dir $(wildcard toolchain/*/Makefile)) ; \
	do \
	    $(MAKE) -C $${tc} clean ; \
	done

toolkit-clean:
	@for tk in $(dir $(wildcard toolkit/*/Makefile)) ; \
	do \
	    $(MAKE) -C $${tk} clean ; \
	done

kernel-clean:
	@for kernel in $(dir $(wildcard kernel/*/Makefile)) ; \
	do \
	    rm -rf $${kernel}/work* ; \
	done

cross-clean:
	@for cross in $(dir $(wildcard cross/*/Makefile)) ; \
	do \
	    $(MAKE) -C $${cross} clean ; \
	done

spk-clean:
	@for spk in $(dir $(wildcard spk/*/Makefile)) ; \
	do \
	    $(MAKE) -C $${spk} clean ; \
	done

%: spk/%/Makefile
	cd $(dir $^) && env $(MAKE)

%-clean: spk/%/Makefile
	cd $(dir $^) && env $(MAKE) clean

native-%: native/%/Makefile
	cd $(dir $^) && env $(MAKE)

native-%-clean: native/%/Makefile
	cd $(dir $^) && env $(MAKE) clean

# build dependency tree for all packages
# and take the tree output only (starting with a tab)
dependency-tree:
	@for spk in $(dir $(wildcard spk/*/Makefile)) ; \
	do \
	    $(MAKE) -C $${spk} dependency-tree | grep -P "^[\t]" ; \
	done

# build dependency list for all packages
dependency-list:
	@for spk in $(dir $(wildcard spk/*/Makefile)) ; \
	do \
	    $(MAKE) -s -C $${spk} dependency-list ; \
	done

# define a template that instantiates a 'python3-avoton-6.1' -style target for
# every ($2) arch, every ($1) spk
define SPK_ARCH_template =
spk-$(1)-$(2): spk/$(1)/Makefile setup
	cd spk/$(1) && env $(MAKE) arch-$(2)
endef
$(foreach arch,$(AVAILABLE_ARCHS),$(foreach spk,$(SUPPORTED_SPKS),$(eval $(call SPK_ARCH_template,$(spk),$(arch)))))

prepare: downloads
	@for tc in $(dir $(wildcard toolchain/*/Makefile)) ; \
	do \
	    $(MAKE) -C $${tc} ; \
	done

downloads:
	@for dl in $(dir $(wildcard cross/*/Makefile)) ; \
	do \
	    $(MAKE) -C $${tc} download ; \
	done

natives:
	@for n in $(dir $(wildcard native/*/Makefile)) ; \
	do \
	    $(MAKE) -C $${n} ; \
	done

native-digests:
	@for n in $(dir $(wildcard native/*/Makefile)) ; \
	do \
	    $(MAKE) -C $${n} digests ; \
	done

toolchain-digests:
	@for tc in $(dir $(wildcard toolchain/*/Makefile)) ; \
	do \
	    $(MAKE) -C $${tc} digests ; \
	done

kernel-digests:
	@for kernel in $(dir $(wildcard kernel/*/Makefile)) ; \
	do \
	    $(MAKE) -C $${kernel} digests ; \
	done

cross-digests:
	@for cross in $(dir $(wildcard cross/*/Makefile)) ; \
	do \
	    $(MAKE) -C $${cross} digests ; \
	done

jsonlint:
ifeq (,$(shell which jsonlint))
	$(error "jsonlint not found, install with: npm install -g jsonlint")
else
	find spk/ -not -path "*work*" -regextype posix-extended -regex '.*(\.json|install_uifile\w*|upgrade_uifile\w*|app/config)' -print -exec jsonlint -q -c {} \;
endif
lint: jsonlint

.PHONY: toolchains kernel-modules
toolchains: $(addprefix toolchain-,$(AVAILABLE_ARCHS))
kernel-modules: $(addprefix kernel-,$(AVAILABLE_ARCHS))

toolchain-%:
	-@cd toolchain/syno-$*/ && MAKEFLAGS= $(MAKE)

kernel-%:
	-@cd kernel/syno-$*/ && MAKEFLAGS= $(MAKE)

setup: local.mk dsm-6.1

local.mk:
	@echo "Creating local configuration \"local.mk\"..."
	@echo "PUBLISH_URL=" > $@
	@echo "PUBLISH_API_KEY=" >> $@
	@echo "MAINTAINER?=" >> $@
	@echo "MAINTAINER_URL=" >> $@
	@echo "DISTRIBUTOR=" >> $@
	@echo "DISTRIBUTOR_URL=" >> $@
	@echo "REPORT_URL=" >> $@
	@echo "DEFAULT_TC=" >> $@
	@echo "#PARALLEL_MAKE=max" >> $@

dsm-%: local.mk
	@echo "Setting default toolchain version to DSM-$*"
	@sed -i "s|DEFAULT_TC.*|DEFAULT_TC=$*|" local.mk

setup-synocommunity: setup
	@sed -i -e "s|PUBLISH_URL=.*|PUBLISH_URL=https://api.synocommunity.com|" \
		-e "s|MAINTAINER?=.*|MAINTAINER?=SynoCommunity|" \
		-e "s|MAINTAINER_URL=.*|MAINTAINER_URL=https://synocommunity.com|" \
		-e "s|DISTRIBUTOR=.*|DISTRIBUTOR=SynoCommunity|" \
		-e "s|DISTRIBUTOR_URL=.*|DISTRIBUTOR_URL=https://synocommunity.com|" \
		-e "s|REPORT_URL=.*|REPORT_URL=https://github.com/SynoCommunity/spksrc/issues|" \
		local.mk
