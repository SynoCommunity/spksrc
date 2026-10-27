###############################################################################
# spksrc.driver.mk
#
# Entry point for driver/<pkg>: an out-of-tree kernel driver, built once per
# kernel against the source of that kernel.
#
# An spk lists driver/<pkg> in its DEPENDS. spksrc.kernel/dependency.mk builds
# it right after each kernel/syno-<arch>-<version> it prepares, with that ARCH
# and TCVERSION and the WORK_DIR of the spk; the regular dependency walk leaves
# it out. The same WORK_DIR then holds every kernel of a generic arch, so:
#   - cookies and the extracted source carry <arch>-<version>
#   - KERNEL_ROOT is the kernel source prepared for that arch, linux-<arch>
#   - DRIVER_MODULE_DIR is where the kernel's own modules go,
#     lib/modules/<arch>/<kernel>
#
# PKG_DIR names the directory inside the archive, as for a cross package: this
# file prefixes it with the per-kernel directory the archive is extracted to.
#
# Variables:
#   DRIVER_KERNEL_MIN  oldest kernel the driver builds for
#   DRIVER_GCC_MIN     oldest gcc it builds with
#   DRIVER_SKIP        why this ARCH is skipped, empty when it builds: a generic
#                      arch has no kernel of its own, and a kernel or gcc below
#                      the floors is left to another version of the driver
#                      (spksrc.driver-virtual.mk)
#
# Main targets:
#   driver-stage1      toolchain and tc_vars*, already there when kernel-depend
#                      runs it
#   driver-stage2      the standard pipeline, download to install
#   all                both, or a message naming DRIVER_SKIP
#   driver-skip        prints DRIVER_SKIP
###############################################################################

URLS          = $(PKG_DIST_SITE)/$(PKG_DIST_NAME)
NAME          = $(PKG_NAME)
ifneq ($(PKG_DIST_FILE),)
LOCAL_FILE    = $(PKG_DIST_FILE)
else
LOCAL_FILE    = $(PKG_DIST_NAME)
endif
DIST_FILE     = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT      = $(PKG_EXT)

ifneq ($(ARCH),)
ARCH_SUFFIX = -$(ARCH)-$(TCVERSION)
ifneq ($(ARCH),noarch)
TC = syno$(ARCH_SUFFIX)
endif
endif

# One cookie set and one source tree per kernel in the shared WORK_DIR
COOKIE_PREFIX = $(PKG_NAME)$(ARCH_SUFFIX)-
EXTRACT_PATH  = $(WORK_DIR)/$(PKG_NAME)$(ARCH_SUFFIX)
PKG_DIR      := $(PKG_NAME)$(ARCH_SUFFIX)/$(PKG_DIR)

.DEFAULT_GOAL := all

include ../../mk/spksrc.common.mk

include ../../mk/spksrc.rules/depend.mk

include ../../mk/spksrc.rules/pre-check.mk

include ../../mk/spksrc.cross/env-default.mk

# The kernel source and module directory of spksrc.kernel.mk for this ARCH. TC_KERNEL
# is read here, as tc_vars.mk sets it with the "+" of 4.4 and newer: a later include of
# spksrc.common.mk resets it to the plain version of the toolchain Makefile.
DRIVER_KERNEL     := $(subst +,,$(TC_KERNEL))
DRIVER_MODULE_DIR := $(STAGING_INSTALL_PREFIX)/lib/modules/$(ARCH)/$(TC_KERNEL)
KERNEL_ROOT        = $(WORK_DIR)/linux-$(ARCH)

include ../../mk/spksrc.rules/dependency.mk

include ../../mk/spksrc.rules/status.mk

ifeq ($(strip $(ARCH)),)
DRIVER_SKIP = no ARCH
else ifneq ($(filter $(ARCH),$(GENERIC_ARCHS)),)
DRIVER_SKIP = $(ARCH) is a generic arch
else ifeq ($(and $(DRIVER_KERNEL_MIN),$(call version_lt,$(DRIVER_KERNEL),$(DRIVER_KERNEL_MIN))),1)
DRIVER_SKIP = kernel $(DRIVER_KERNEL) < $(DRIVER_KERNEL_MIN)
else ifeq ($(and $(DRIVER_GCC_MIN),$(call version_lt,$(TC_GCC),$(DRIVER_GCC_MIN))),1)
DRIVER_SKIP = gcc $(TC_GCC) < $(DRIVER_GCC_MIN)
endif

include ../../mk/spksrc.build.mk

plist: install
include ../../mk/spksrc.build/plist.mk

TCVARS_DONE := $(WORK_DIR)/.stage1-tcvars_done

.PHONY: driver-stage1
driver-stage1: $(TCVARS_DONE)

ifneq ($(strip $(TC)),)
$(TCVARS_DONE):
	@$(MAKE) WORK_DIR=$(TC_WORK_DIR) $(FWRD_ARGS) --no-print-directory -C ../../toolchain/$(TC) toolchain
	@$(MAKE) WORK_DIR=$(WORK_DIR) $(FWRD_ARGS) --no-print-directory -C ../../toolchain/$(TC) tcvars
else
$(TCVARS_DONE): ;
endif

.PHONY: driver-stage2
driver-stage2: install plist

.PHONY: all
ifeq ($(strip $(DRIVER_SKIP)),)
# Once installed, the kernel source may be gone: a multi-kernel build removes it
all:
	@test -f $(WORK_DIR)/.$(COOKIE_PREFIX)install_done -o -f $(KERNEL_ROOT)/Makefile || { $(MSG) "$(NAME): no kernel source in $(KERNEL_ROOT), build it from an spk" ; exit 1 ; }
	@mkdir -p $(WORK_DIR)
	$(call RUNLOG,driver-stage1)
	$(call RUNLOG,driver-stage2)
else
all:
	@$(MSG) "Skipping $(NAME) for $(ARCH)-$(TCVERSION): $(DRIVER_SKIP)"
endif

.PHONY: driver-skip
driver-skip:
	@echo "$(DRIVER_SKIP)"

include ../../mk/spksrc.rules/supported.mk
