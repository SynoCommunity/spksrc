###

# Find the kernel architecture being processed
KO_ARCH = $(or $(ARCH),$(firstword $(subst -, ,$*)))
KO_TCVERSION = $(or $(TCVERSION),$(word 2,$(subst -, ,$*)))

ifeq ($(strip $(REQUIRE_KERNEL)),1)

ifneq ($(strip $(REQUIRE_KERNEL_MODULE)),)
ENV += REQUIRE_KERNEL_MODULE="$(REQUIRE_KERNEL_MODULE)"

# Add to the dependency list if not a generic arch
ifneq ($(findstring $(KO_ARCH),$(GENERIC_ARCHS)),$(KO_ARCH))
KERNEL_DEPEND = $(KO_ARCH)-$(KO_TCVERSION)

# else only process matching <arch>-<#>
else
KERNEL_DEPEND = $(filter $(addsuffix -$(KO_TCVERSION),$(filter-out $(UNSUPPORTED_ARCHS),$(shell sed -n -e '/TC_ARCH/ s/.*= *//p' ../../toolchain/syno-$(KO_ARCH)-$(KO_TCVERSION)/Makefile 2>/dev/null))), $(LEGACY_ARCHS))
endif

# end REQUIRE_KERNEL_MODULE
endif

# end REQUIRE_KERNEL
endif

####

.PHONY: kernel-depend
kernel-depend:
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
