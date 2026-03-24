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
#  - The -include directive makes the file optional; a missing tc_vars.mk
#    is silently ignored (TC not yet built)
#  - STAGE0_DONE sentinel file is touched after generation
#
###############################################################################

STAGE0_DONE := $(WORK_DIR)/.stage0-tcvars_done

# Load toolchain variables early (provides TC_GCC, TC_VERS, TC_ARCH etc.)
# - if TC does not exists then tc_vars.mk is not generated yet
# - this occurs when MAKECMDGOALS is empty, thur prior to stage1 or stage2
ifneq ($(ARCH),noarch)
ifeq ($(MAKECMDGOALS),)
ifeq ($(TC),)
ifeq ($(wildcard $(STAGE0_DONE)),)
  $(info ===> Generating $(WORK_DIR)/tc_vars.mk (stage0))
  $(shell mkdir -p $(WORK_DIR))
  $(shell $(MAKE) --no-print-directory -C $(BASEDIR)/toolchain/syno-$(ARCH)-$(TCVERSION) MSG= tc_vars > $(WORK_DIR)/tc_vars.mk 2>/dev/null)
  $(shell touch $(STAGE0_DONE))
endif
endif
endif
endif

-include $(WORK_DIR)/tc_vars.mk
