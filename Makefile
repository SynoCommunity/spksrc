
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

spk_comcerto2k:
	@for spk in $(dir $(wildcard spk/*/Makefile)) ; \
	do \
	    (cd $${spk} && $(MAKE) arch-comcerto2k) ; \
	done

spk-all:
	@for spk in $(dir $(wildcard spk/*/Makefile)) ; \
	do \
	    (cd $${spk} && $(MAKE) arch-88f5281) ; \
	    (cd $${spk} && $(MAKE) arch-88f6281) ; \
	    (cd $${spk} && $(MAKE) arch-armada370) ; \
	    (cd $${spk} && $(MAKE) arch-armadaxp) ; \
	    (cd $${spk} && $(MAKE) arch-bromolow) ; \
	    (cd $${spk} && $(MAKE) arch-cedarview) ; \
	    (cd $${spk} && $(MAKE) arch-evansport) ; \
	    (cd $${spk} && $(MAKE) arch-ppc824x) ; \
	    (cd $${spk} && $(MAKE) arch-ppc853x) ; \
	    (cd $${spk} && $(MAKE) arch-ppc854x) ; \
	    (cd $${spk} && $(MAKE) arch-powerpc) ; \
	    (cd $${spk} && $(MAKE) arch-qoriq) ; \
	    (cd $${spk} && $(MAKE) arch-x86) ; \
	    (cd $${spk} && $(MAKE) arch-comcerto2k) ; \
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
toolchains: $(addprefix toolchain-,$(SUPPORTED_ARCHS))
kernel-modules: $(addprefix kernel-,$(SUPPORTED_ARCHS))

toolchain-%:
	-@cd toolchains/syno-$*/ && MAKEFLAGS= $(MAKE)

kernel-%:
	-@cd kernel/syno-$*/ && MAKEFLAGS= $(MAKE)

setup: local.mk

local.mk:
	@echo "Creating local configuration \"local.mk\"..."
	@echo "PUBLISH_METHOD=REPO" > $@
	@echo "PUBLISH_REPO_URL=http://packages.synocommunity.com/" >> $@
	@echo "PUBLISH_REPO_KEY=" >> $@
	@echo "PUBLISH_FTP_URL=ftp://synocommunity.com/upload_spk" >> $@
	@echo "PUBLISH_FTP_USER=" >> $@
	@echo "PUBLISH_FTP_PASSWORD=" >> $@
