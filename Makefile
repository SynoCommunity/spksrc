
AVAILABLE_TCS = $(notdir $(wildcard toolchains/syno-*))
AVAILABLE_ARCHS = $(notdir $(subst syno-,/,$(AVAILABLE_TCS)))
SUPPORTED_SPKS = $(patsubst spk/%/Makefile,%,$(wildcard spk/*/Makefile))


all: $(SUPPORTED_SPKS)

clean: $(addsuffix -clean,$(SUPPORTED_SPKS))
clean: native-clean

dist-clean: clean
dist-clean: toolchain-clean

native-clean:
	@for native in $(dir $(wildcard native/*/Makefile)) ; \
	do \
	    (cd $${native} && $(MAKE) clean) ; \
	done

toolchain-clean:
	@for tc in $(dir $(wildcard toolchains/*/Makefile)) ; \
	do \
	    (cd $${tc} && $(MAKE) clean) ; \
	done

kernel-clean:
	@for kernel in $(dir $(wildcard kernel/*/Makefile)) ; \
	do \
	    (cd $${kernel} && $(MAKE) clean) ; \
	done

cross-clean:
	@for cross in $(dir $(wildcard cross/*/Makefile)) ; \
	do \
	    (cd $${cross} && $(MAKE) clean) ; \
	done

spk-clean:
	@for spk in $(dir $(wildcard spk/*/Makefile)) ; \
	do \
	    (cd $${spk} && $(MAKE) clean) ; \
	done

%: spk/%/Makefile
	cd $(dir $^) && env $(MAKE)

%-clean: spk/%/Makefile
	cd $(dir $^) && env $(MAKE) clean

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

prepare: downloads
	@for tc in $(dir $(wildcard toolchains/*/Makefile)) ; \
	do \
	    (cd $${tc} && $(MAKE)) ; \
	done

downloads:
	@for dl in $(dir $(wildcard cross/*/Makefile)) ; \
	do \
	    (cd $${dl} && $(MAKE) download) ; \
	done

natives:
	@for n in $(dir $(wildcard native/*/Makefile)) ; \
	do \
	    (cd $${n} && $(MAKE)) ; \
	done

native-digests:
	@for n in $(dir $(wildcard native/*/Makefile)) ; \
	do \
	    (cd $${n} && $(MAKE) digests) ; \
	done

toolchain-digests:
	@for tc in $(dir $(wildcard toolchains/*/Makefile)) ; \
	do \
	    (cd $${tc} && $(MAKE) digests) ; \
	done

kernel-digests:
	@for kernel in $(dir $(wildcard kernel/*/Makefile)) ; \
	do \
	    (cd $${kernel} && $(MAKE) digests) ; \
	done

cross-digests:
	@for cross in $(dir $(wildcard cross/*/Makefile)) ; \
	do \
	    (cd $${cross} && $(MAKE) digests) ; \
	done

.PHONY: toolchains kernel-modules
toolchains: $(addprefix toolchain-,$(AVAILABLE_ARCHS))
kernel-modules: $(addprefix kernel-,$(AVAILABLE_ARCHS))

toolchain-%:
	-@cd toolchains/syno-$*/ && MAKEFLAGS= $(MAKE)

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

