###############################################################################
# mk/spksrc.common/stage0.mk
#
# Bootstraps the toolchain and its environment definitions BEFORE a package's
# DEPENDS are parsed, so that version_ge($(TC_GCC),...) gated dependencies
# (shaderc, vulkan, numpy, ...) are evaluated against a real GCC version
# instead of an empty TC_GCC. This applies to BOTH cross/ packages (cross-cc.mk)
# and spk/ packages (spk.mk) -- the latter resolve their meta DEPENDS at parse.
#
# For the very first package built in a cold tree the toolchain is not yet
# extracted, so `<cross>-gcc -dumpversion` returns an EMPTY TC_GCC. This file
# reproduces stage1's two calls (see mk/spksrc.cross-cc.mk) early enough for
# the DEPENDS parse:
#   1. build/extract the toolchain into its OWN work dir (target: toolchain)
#   2. generate tc_vars*.mk into THIS package's WORK_DIR    (target: tcvars)
# then -include the generated $(WORK_DIR)/tc_vars.mk (provides TC_GCC, ...).
#
# Both sub-makes are idempotent (cookie-guarded): once the toolchain is built
# and tc_vars generated, they are no-ops.
#
# Guards:
#  - ARCH set and not noarch (or TCVERSION set).
#  - NOT building inside the toolchain directory: when stage0 spawns the
#    `toolchain`/`tcvars` sub-makes, their CURDIR contains "toolchain", so this
#    guard makes stage0 a no-op there -> no recursion, no contamination. (This
#    is also why we do NOT guard on `$(TC)`: spk.mk sets TC before including
#    common.mk, and guarding on it would wrongly skip stage0 for every spk,
#    leaving their TC_GCC-gated DEPENDS empty at parse.)
#  - Bootstrap (the heavy sub-makes) only runs when no explicit build goal is
#    given (MAKECMDGOALS empty, or only dependency-% recipes) and STAGE0_DONE is
#    absent. The real build reaches the package parse via `$(MAKE) ARCH=.. TCVERSION=..`
#    with NO goal (mk/spksrc.supported.mk build-arch-%), so the bootstrap fires.
#  - tc_vars.mk is -included unconditionally (broad) so the parse sees TC_GCC
#    whenever it has already been generated, regardless of goal.
#
# Important:
#  - Do NOT override MSG (e.g. `MSG=`). MSG defaults to `echo "===> "`; blanking
#    it turns the toolchain_msg recipe line `$(MSG) "Preparing toolchain..."`
#    into a bare `"Preparing toolchain..."`, which the shell tries to EXECUTE as
#    a command -> Error 127, aborting the toolchain build before anything is
#    downloaded/extracted. On a populated tree the toolchain cookie already
#    exists so toolchain_msg never runs, which is why this stayed hidden on CI.
#  - The sub-make stdout is redirected to stderr (`>&2`), NOT captured. $(shell)
#    only captures fd 1, so sending the build output to fd 2 keeps it out of the
#    makefile parse (no injection / broken parse) while still showing it on the
#    console and in the build logs. (Using `>/dev/null` would also keep the parse
#    safe but would hide the toolchain build progress from the console.)
#  - STAGE0_DONE is only touched once TC_GCC actually resolved; otherwise it is
#    left unmarked so the next invocation retries instead of freezing an empty
#    TC_GCC.
#
###############################################################################

# stage0-private sentinel (no collision with the toolchain namespace)
STAGE0_DONE := $(WORK_DIR)/.stage0-tcvars_done

ifneq ($(filter-out noarch,$(ARCH))$(TCVERSION),)
ifeq ($(filter toolchain,$(subst /, ,$(CURDIR))),)

# Toolchain-namespace vars -- defined INSIDE the "not in toolchain dir" guard so
# they can never clobber spksrc.toolchain.mk's own definitions during a toolchain
# build (there ARCH/TCVERSION are empty -> a bogus syno--/work path; and TC_WORK_DIR
# in particular is `?=` there, so it would keep our wrong value).
TC_VARS_MK  := $(WORK_DIR)/tc_vars.mk
TC_WORK_DIR := $(abspath $(BASEDIR)/toolchain/syno-$(ARCH)-$(TCVERSION)/work)

# Bootstrap (heavy) only when no explicit build goal and not yet done
ifeq ($(filter-out dependency-%,$(MAKECMDGOALS)),)
ifeq ($(wildcard $(STAGE0_DONE)),)
  ifeq ($(wildcard $(TC_VARS_MK)),)
    $(info ===> Bootstrapping toolchain for $(ARCH)-$(TCVERSION) (stage0))
  endif
  $(shell mkdir -p $(WORK_DIR))
  $(shell $(MAKE) WORK_DIR=$(TC_WORK_DIR) --no-print-directory -C $(BASEDIR)/toolchain/syno-$(ARCH)-$(TCVERSION) toolchain >&2)
  $(shell $(MAKE) WORK_DIR=$(WORK_DIR) --no-print-directory -C $(BASEDIR)/toolchain/syno-$(ARCH)-$(TCVERSION) tcvars >&2)
endif
endif

# Load toolchain variables for the parse (provides TC_GCC, TC_VERS, ...)
-include $(TC_VARS_MK)

# Checkpoint once TC_GCC actually resolved so the bootstrap is not retried
ifeq ($(wildcard $(STAGE0_DONE)),)
ifneq ($(strip $(TC_GCC)),)
  $(shell touch $(STAGE0_DONE))
endif
endif

endif
endif
