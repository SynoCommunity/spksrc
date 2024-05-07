###

# Find the kernel architecture being processed
KO_ARCH = $(or $(ARCH),$(firstword $(subst -, ,$*)))
KO_TCVERSION = $(or $(TCVERSION),$(word 2,$(subst -, ,$*)))
KERNEL_ROOT = $(WORK_DIR)/linux
ENV += KERNEL_ROOT=$(KERNEL_ROOT)

ifeq ($(strip $(REQUIRE_KERNEL)),1)

ifeq ($(strip $(REQUIRE_KERNEL_MODULE)),)
ENV += REQUIRE_KERNEL_MODULE="$(REQUIRE_KERNEL_MODULE)"
KERNEL_ROOT = $(WORK_DIR)/linux
ENV += KERNEL_ROOT=$(KERNEL_ROOT)

# else REQUIRE_KERNEL_MODULE
else

# Add to the dependency list if not a generic arch
ifneq ($(findstring $(KO_ARCH),$(GENERIC_ARCHS)),$(KO_ARCH))
KERNEL_DEPEND = kernel/syno-$(KO_ARCH)-$(KO_TCVERSION)
KERNEL_MODULE_DEPEND = $(KERNEL_DEPEND)

# else it's generic, then find the list of arch to be processed
# if version needed is part of the default toolchain supported versions
# then process all matching <arch>-<#>.* archs
else ifneq ($(filter $(KO_TCVERSION),$(DEFAULT_TC)),)
KERNEL_MODULE_DEPEND = $(filter $(addsuffix -$(firstword $(subst ., ,$(KO_TCVERSION))).%,$(filter-out $(UNSUPPORTED_ARCHS),$(shell sed -n -e '/TC_ARCH/ s/.*= *//p' ../../toolchain/syno-$(KO_ARCH)-$(KO_TCVERSION)/Makefile 2>/dev/null))), $(LEGACY_ARCHS))

# else only process matching <arch>-<#>
else
KERNEL_MODULE_DEPEND = $(filter $(addsuffix -$(KO_TCVERSION),$(filter-out $(UNSUPPORTED_ARCHS),$(shell sed -n -e '/TC_ARCH/ s/.*= *//p' ../../toolchain/syno-$(KO_ARCH)-$(KO_TCVERSION)/Makefile 2>/dev/null))), $(LEGACY_ARCHS))
endif

# end REQUIRE_KERNEL_MODULE
endif

# end REQUIRE_KERNEL
endif

###
