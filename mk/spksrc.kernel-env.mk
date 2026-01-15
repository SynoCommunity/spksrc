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

###
