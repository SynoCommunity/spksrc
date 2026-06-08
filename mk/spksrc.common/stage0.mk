###############################################################################
# mk/spksrc.common/stage0.mk
#
# Bootstraps minimal toolchain variables before any build stage runs.
#
# This file:
#  - generates $(WORK_DIR)/tc_vars.mk via the toolchain's tc_vars target
#    when no explicit goal is specified (i.e. before stage1 / stage2)
#  - skips generation for noarch packages or when the TC is already set
#  - includes the generated tc_vars.mk (silently, with -include)
#
# Variables produced (via tc_vars.mk):
#  TC_GCC   : GCC version used by the toolchain
#  TC_VERS  : toolchain version string
#  TC_ARCH  : target CPU architecture
#  (and other toolchain-specific variables exported by tc_vars)
#
# Notes:
#  - Generation is guarded by MAKECMDGOALS == "" to avoid re-running
#    during explicit sub-targets (stage1, stage2, clean, …)
#  - Also guarded against running in toolchain directory which actually
#    means we're in stage1 and could comtaminate resulting toolchain install
#  - The -include directive makes the file optional; a missing tc_vars.mk
#    is silently ignored (TC not yet built)
#  - STAGE0_DONE sentinel file is touched after generation
#
###############################################################################

STAGE0_DONE := $(WORK_DIR)/.stage0-tcvars_done
TC_VARS_MK := $(WORK_DIR)/tc_vars.mk

# Load toolchain variables early (provides TC_GCC, TC_VERS, TC_ARCH etc.)
# - if ARCH and TCVERSION are set and is not noarch
# - if MAKECMDGOALS is empty, thus prior to stage1 or stage2 (unless called from dependency-* recipes)
# - if TC does not exists then tc_vars.mk is not generated yet
# - do not print info msg if called from dependency-* recipes
ifneq ($(filter-out noarch,$(ARCH))$(TCVERSION),)
ifeq ($(filter-out dependency-%,$(MAKECMDGOALS)),)
ifeq ($(filter toolchain,$(subst /, ,$(CURDIR))),)
ifeq ($(TC),)
ifeq ($(wildcard $(STAGE0_DONE)),)
  ifeq ($(filter dependency-%,$(MAKECMDGOALS)),)
    $(info ===> Generating $(TC_VARS_MK) (stage0))
  endif
  $(shell mkdir -p $(WORK_DIR))
  # Make sure the cross toolchain is actually extracted BEFORE reading tc_vars: the
  # tc_vars target derives TC_GCC by running `<cross>-gcc -dumpversion`, which returns
  # an EMPTY TC_GCC when the toolchain binaries are not unpacked yet. For the very first
  # package built in a clean tree the toolchain is still cold at this point, so an empty
  # TC_GCC would silently drop every version_gt($(TC_GCC),...) gated DEPENDS (shaderc,
  # vulkan, opencl, ...). Reproduce stage1 here (it is cookie-guarded -> no-op once the
  # toolchain is built): first build/extract the toolchain into its own work dir, then
  # generate the tc_vars*.mk set into this package WORK_DIR -- exactly the two calls
  # cross-cc.mk / spk.mk used to do at stage1, but early enough for the DEPENDS parse.
  # `tcvars` WRITES $(WORK_DIR)/tc_vars*.mk itself (it does not echo to stdout like the
  # `tc_vars` target), so no `> file` redirection. stdout is sent to /dev/null only to
  # keep the sub-make's output from being captured by $(shell) and injected into this
  # makefile (which would break the parse); stderr is left ALONE so real toolchain
  # build/extract errors stay visible in the build log.
  TC_WORK_DIR := $(abspath $(BASEDIR)/toolchain/syno-$(ARCH)-$(TCVERSION)/work)
  $(shell $(MAKE) WORK_DIR=$(TC_WORK_DIR) --no-print-directory -C $(BASEDIR)/toolchain/syno-$(ARCH)-$(TCVERSION) MSG= toolchain >/dev/null)
  $(shell $(MAKE) WORK_DIR=$(WORK_DIR) --no-print-directory -C $(BASEDIR)/toolchain/syno-$(ARCH)-$(TCVERSION) MSG= tcvars >/dev/null)
  $(eval -include $(TC_VARS_MK))
  # Only mark stage0 done once TC_GCC actually resolved (the toolchain gcc was present).
  # Otherwise leave it UNMARKED so the next make invocation regenerates, instead of
  # freezing an empty TC_GCC that would silently drop every version_gt($(TC_GCC),...)
  # gated DEPENDS for the very first package built in a cold tree.
  ifneq ($(strip $(TC_GCC)),)
  $(shell touch $(STAGE0_DONE))
  endif
endif
endif
endif
endif
endif

-include $(WORK_DIR)/tc_vars.mk
