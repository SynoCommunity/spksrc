###############################################################################
# spksrc.kernel/required.mk
#
# Kernel requirement checker for spksrc.
#
# Purpose:
#  - Determine whether any of the current package dependencies require
#    kernel sources or kernel modules to be built.
#  - Provides a subroutine that returns non-zero if no kernel is required
#    or zero if at least one dependency requires kernel/module build.
#
# Variables:
#   KERNEL_REQUIRED             result of the kernel-required check
#   REQUIRE_KERNEL              set when kernel build is explicitly requested
#   REQUIRE_KERNEL_MODULE       set when kernel modules are explicitly requested
#   ARCHS_WITH_KERNEL_SUPPORT   list of architectures supported by kernel
#   BUILD_DEPENDS / DEPENDS     package dependencies to inspect
#
# Targets:
#   kernel-required             subroutine used to check dependencies for kernel requirements
#
# Behavior:
#  - Checks if either REQUIRE_KERNEL or REQUIRE_KERNEL_MODULE is set
#  - Iterates over BUILD_DEPENDS and DEPENDS, recursively calling kernel-required
#    on each dependency
#  - Returns:
#       * exit code 0 if at least one dependency requires kernel/module
#       * exit code 1 if no kernel-related requirement is found
#
###############################################################################

KERNEL_REQUIRED = $(MAKE) kernel-required
ifeq ($(strip $(KERNEL_REQUIRED)),)
ALL_ACTION = $(sort $(basename $(subst -,.,$(basename $(subst .,,$(ARCHS_WITH_KERNEL_SUPPORT))))))
endif

#### used as subroutine to test whether any dependency has REQUIRE_KERNEL defined

.PHONY: kernel-required
kernel-required:
	@if [ -n "$(REQUIRE_KERNEL)" -o -n "$(REQUIRE_KERNEL_MODULE)" ]; then \
	  exit 1 ; \
	fi
	@for depend in $(BUILD_DEPENDS) $(DEPENDS) ; do \
	  if $(MAKE) --no-print-directory -C ../../$$depend kernel-required >/dev/null 2>&1 ; then \
	    exit 0 ; \
	  else \
	    exit 1 ; \
	  fi ; \
	done

####
