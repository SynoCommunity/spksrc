
SUPPORTED_TCS = $(notdir $(wildcard toolchains/syno-*))
SUPPORTED_ARCHS = $(notdir $(subst -,/,$(SUPPORTED_TCS)))
SUPPORTED_SPKS = $(patsubst spk/%/Makefile,%,$(wildcard spk/*/Makefile))


all: $(SUPPORTED_SPKS)

clean: $(addsuffix -clean,$(SUPPORTED_SPKS)) 
clean: native-clean

dist-clean: clean
dist-clena: toolchain-clean

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

.PHONY: toolchains kernel-modules

TOOLCHAINS = $(addprefix toolchain-,$(SUPPORTED_ARCHS))

toolchains: $(TOOLCHAINS)
kernel-modules: $(addprefix kernel-,$(SUPPORTED_ARCHS))

$(TOOLCHAINS):
	-@cd toolchains/syno-$(subst toolchain-,,$(@))/ && MAKEFLAGS= $(MAKE)

kernel-%:
	-@cd kernel/syno-$*/ && MAKEFLAGS= $(MAKE)

setup: local.mk

local.mk:
	@echo "Creating local configuration \"local.mk\"..."
	@echo "PUBLISH_METHOD=REPO" > $@
	@echo "PUBLISH_REPO_URL=https://packages.synocommunity.com/" >> $@
	@echo "PUBLISH_REPO_KEY=" >> $@
	@echo "PUBLISH_FTP_URL=ftp://synocommunity.com/upload_spk" >> $@
	@echo "PUBLISH_FTP_USER=" >> $@
	@echo "PUBLISH_FTP_PASSWORD=" >> $@
