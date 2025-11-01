####

# kernel arch definitions
include $(BASEDIR)mk/spksrc.kernel-env.mk

###

kernel-modules: SHELL:=/bin/bash
kernel-modules:
	@$(MSG) "kernel-modules archs to be processed: $(KERNEL_DEPEND)" ; \
	rsync -ah --mkpath work$(ARCH_SUFFIX)/tc_vars* work$(ARCH_SUFFIX)/tc_vars-backup ; \
	BUILD_SUCCESS=true ; \
	for depend in $(KERNEL_DEPEND); do \
	  set -o pipefail; { \
	  $(MSG) "Building kernel-modules for $${depend} ARCH" ; \
	  $(MAKE) spkclean ; \
	  $(MSG) "$$(date +%Y%m%d-%H%M%S) MAKELEVEL: $(MAKELEVEL), PARALLEL_MAKE: $(PARALLEL_MAKE), ARCH: $(ARCH)-$(TCVERSION), NAME: kernel-modules-$${depend}-$(TCVERSION) [BEGIN]" >> $(PSTAT_LOG) ; \
	  if ! $(PSTAT_TIME) $(MAKE) WORK_DIR=$(CURDIR)/work$(ARCH_SUFFIX) \
	          REQUIRE_KERNEL_MODULE="$(REQUIRE_KERNEL_MODULE)" \
	          ARCH=$$(echo $${depend} | cut -f1 -d-) \
	          TCVERSION=$$(echo $${depend} | cut -f2 -d-) \
	          -C ../../kernel/syno-$$depend ; then \
	    $(MSG) "ERROR: Build failed for $${depend}" ; \
	    BUILD_SUCCESS=false; \
	  fi; \
	  $(MSG) "$$(date +%Y%m%d-%H%M%S) MAKELEVEL: $(MAKELEVEL), PARALLEL_MAKE: $(PARALLEL_MAKE), ARCH: $(ARCH)-$(TCVERSION), NAME: kernel-modules-$${depend}-$(TCVERSION) [END]" >> $(PSTAT_LOG) ; \
	  if [ "$$BUILD_SUCCESS" = "true" ]; then \
	    $(MSG) "All kernel modules built successfully - cleaning up sources" ; \
	    for depend in $(KERNEL_DEPEND); do \
	      rm -fr $(CURDIR)/work$(ARCH_SUFFIX)/linux-$${depend} ; \
	    done ; \
	  else \
	    $(MSG) "Build failed - keeping sources for debugging" ; \
	    exit 1; \
	  fi; \
	  } > >(tee --append build-$(ARCH)-$(TCVERSION)-kernel-modules-$${depend}.log) 2>&1 ; [ $${PIPESTATUS[0]} -eq 0 ] || false ; \
	done ; \
	rsync -ah work$(ARCH_SUFFIX)/tc_vars-backup/tc_vars* work$(ARCH_SUFFIX)/. ; \

###
