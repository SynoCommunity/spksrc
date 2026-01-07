####

# kernel arch definitions
include $(BASEDIR)mk/spksrc.kernel-env.mk

###

kernel-modules:
	@bash -e -o pipefail -c ' \
	{ \
	  $(MSG) "kernel-modules archs to be processed: $(KERNEL_DEPEND)" ; \
	  rsync -ah --mkpath work$(ARCH_SUFFIX)/tc_vars* work$(ARCH_SUFFIX)/tc_vars-backup ; \
	  for depend in $(KERNEL_DEPEND); \
	  do \
	    { \
	      $(MAKE) spkclean ; \
	      $(MSG) "Building kernel-modules for $${depend} ARCH" ; \
	      if ! $(MAKE) LOGGING_ENABLED=1 \
	          WORK_DIR=$(CURDIR)/work$(ARCH_SUFFIX) \
	          REQUIRE_KERNEL_MODULE="$(REQUIRE_KERNEL_MODULE)" \
	          ARCH=$$(echo $${depend} | cut -f1 -d-) \
	          TCVERSION=$$(echo $${depend} | cut -f2 -d-) \
	          -C ../../kernel/syno-$${depend} ; then \
	        $(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, DEPEND: %s, NAME: %s - FAILED\n" \
	          "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "$${depend}" "kernel-modules") | tee --append $(STATUS_LOG) ; \
	        exit 1 ; \
	      fi ; \
	      rm -fr $(CURDIR)/work$(ARCH_SUFFIX)/linux-$${depend} ; \
	    } > >(tee --append build-$${depend}.log) 2>&1 ; \
	  done ; \
	  rsync -ah work$(ARCH_SUFFIX)/tc_vars-backup/tc_vars* work$(ARCH_SUFFIX)/. ; \
	}'

###
