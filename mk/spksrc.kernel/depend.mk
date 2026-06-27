###############################################################################
# spksrc.kernel/depend.mk
#
# Kernel module dependency manager for spksrc.
#
# Purpose:
#  - Determine which kernel architectures require module compilation.
#  - Handle generic architectures (e.g., x64) that contain multiple
#    sub-architectures (e.g., denverton, apollolake). In this case:
#      * Backup tc_vars* cookies for the generic arch
#      * Loop through each sub-architecture and build required kernel modules
#      * Restore the generic arch tc_vars* cookies after processing
#
# This ensures that:
#  - The generic arch environment remains consistent for other package builds
#  - Module builds are executed per sub-arch
#  - Logging and error handling are centralized
#
# Variables:
#   KO_ARCH                : the kernel architecture being processed
#   KO_TCVERSION           : toolchain version for this kernel
#   REQUIRE_KERNEL         : enables dependency processing
#   REQUIRE_KERNEL_MODULE  : list of kernel modules to build
#   GENERIC_ARCHS          : architectures that serve as anchors for multiple sub-archs
#   UNSUPPORTED_ARCHS      : toolchain architectures that cannot be built
#   LEGACY_ARCHS           : fallback list of known architectures
#   KERNEL_DEPEND          : architectures/sub-archs selected for module build
#   WORK_DIR               : base working directory
#   ARCH_SUFFIX            : optional suffix for WORK_DIR
#   STATUS_LOG             : centralized build log
#
# Targets:
#   kernel-depend          : process kernel module dependencies
#                           for the current ARCH/generic-ARCH context
#
# Behavior:
#  - Generic architectures are used as anchors to iterate over sub-architectures
#  - Only non-generic sub-architectures are built
#  - Each sub-arch build occurs in its own WORK_DIR
#  - Build logs are written to build-<arch>-<tcversion>.log
#  - tc_vars* files are backed up/restored for generic architectures
#  - Called by spksrc.depend.mk via depend_target if REQUIRE_KERNEL_MODULE is set
###############################################################################

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
	    } > >(tee --append build-$${depend}.log) 2>&1 ; \
	  done ; \
	  rsync -ah work$(ARCH_SUFFIX)/tc_vars-backup/tc_vars* work$(ARCH_SUFFIX)/. ; \
	}'

###
