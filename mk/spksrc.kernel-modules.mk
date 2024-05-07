####

# kernel arch definitions
include $(BASEDIR)mk/spksrc.kernel-env.mk

###

kernel-modules-%: SHELL:=/bin/bash
kernel-modules-%:
	@$(MSG) ARCH to be processed: $(KERNEL_MODULE_DEPEND)
	@for arch in $(KERNEL_MODULE_DEPEND) ; do \
	  $(MSG) "Building kernel-modules for $${arch} ARCH" | tee --append build-$*-kernel-modules-$${arch}.log ; \
	  $(MSG) "$$(date +%Y%m%d-%H%M%S) MAKELEVEL: $(MAKELEVEL), PARALLEL_MAKE: $(PARALLEL_MAKE), ARCH: $${arch}, NAME: kernel-modules-$* [BEGIN]" >> $(PSTAT_LOG) ; \
	  MAKEFLAGS= $(PSTAT_TIME) $(MAKE) WORK_DIR=$(CURDIR)/work-$* ARCH=$$(echo $${arch} | cut -f1 -d-) TCVERSION=$$(echo $${arch} | cut -f2 -d-) strip 2>&1 | tee --append build-$*-kernel-modules-$${arch}.log ; \
	  [ $${PIPESTATUS[0]} -eq 0 ] || false ; \
	  $(MSG) "$$(date +%Y%m%d-%H%M%S) MAKELEVEL: $(MAKELEVEL), PARALLEL_MAKE: $(PARALLEL_MAKE), ARCH: $${arch}, NAME: kernel-modules-$* [END]" >> $(PSTAT_LOG) ; \
	  $(MAKE) spkclean ; \
	  rm -fr $(CURDIR)/work-$*/$(addprefix linux-, $${arch}) ; \
	  if [ "$$(basename $(abspath $(CURDIR)/$(BASEDIR)))" = "workspace" ]; then \
	     $(MAKE) -C ../../toolchain/syno-$${arch} clean ; \
	  fi ; \
	done

kernel-arch-%:
	$(MAKE) $(addprefix kernel-modules-, $(or $(filter $(addprefix %, $(DEFAULT_TC)), $(filter %$(word 2,$(subst -, ,$*)), $(filter $(firstword $(subst -, ,$*))%, $(AVAILABLE_TOOLCHAINS)))),$*)) | tee --append build-$*.log
