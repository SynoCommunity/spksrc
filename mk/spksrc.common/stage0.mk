###############################################################################
# spksrc.common/stage0.mk
#
# Early toolchain bootstrap: resolves TC_GCC (and TC_VERS, TC_KERNEL, ...)
# BEFORE the package's DEPENDS are parsed, so version_ge($(TC_GCC),...) gated
# dependencies (shaderc, vulkan, numpy, ...) evaluate against a real GCC
# version instead of an empty one on a cold tree. Applies to both cross/ and
# spk/ packages.
#
# ┌──────────────────────────────────────────────────────────────────────┐
# │ stage0  (PARSE time, this file) -- two steps, guarded separately     │
# │                                                                      │
# │ 1. IDENTITY, every parse. Witness: the file itself.                  │
# │                                                                      │
# │   <pkg work dir>/tc_vars.mk missing?                                 │
# │        ▼                                                             │
# │   make WORK_DIR=<pkg work dir> -C toolchain/<TC> tcvars-identity     │
# │        └─ writes <pkg work dir>/tc_vars.mk. Needs NO extracted       │
# │           toolchain: every value is a constant of its Makefile       │
# │        ▼                                                             │
# │   -include <pkg work dir>/tc_vars.mk  ->  TC_GCC, TC_VERS, ...       │
# │        ▼                                                             │
# │   DEPENDS parse evaluates version_ge($(TC_GCC),...) correctly        │
# │                                                                      │
# │ 2. TOOLCHAIN, once per arch: the first build for it in a fresh tree, │
# │    then never again. Step 1 does not lead here, the two are          │
# │    independent -- and a goal named on the command line skips this,   │
# │    stage1 doing the real bootstrap in that case.                     │
# │                                                                      │
# │   no explicit goal AND <TC work dir>/<TC_TARGET> missing?            │
# │        ▼                                                             │
# │   make WORK_DIR=<TC work dir> -C toolchain/<TC> toolchain            │
# │        └─ download / extract / patch / rust  (cookie-guarded)        │
# │        └─ on success only: touch <pkg work dir>/.stage0-bootstrap_   │
# │           done, tracing WHICH package paid for the extraction        │
# └──────────────────────────────────────────────────────────────────────┘
#                                  │
#                                  ▼  (recipes run after parse)
# ┌──────────────────────────────────────────────────────────────────────┐
# │ stage1  (RECIPE time, cross-cc.mk / spk.mk) -- ALWAYS runs           │
# │                                                                      │
# │   Guarded by <pkg work dir>/.stage1-tcvars_done, which stage0 never  │
# │   writes: a toolchain already extracted does not skip it, the local  │
# │   tc_vars* still have to be made for THIS package.                   │
# │                                                                      │
# │   make -C toolchain/<TC> toolchain -> no-op when step 2 already ran; │
# │                                       the REAL bootstrap when a goal │
# │                                       on the command line skipped it │
# │   make WORK_DIR=<pkg work dir> \                                     │
# │        -C toolchain/<TC> tcvars    -> the six OTHER tc_vars* files;  │
# │                                       they embed INSTALL_PREFIX,     │
# │                                       recipe ENV stage0 cannot see.  │
# │                                       tc_vars.mk is already correct  │
# │                                       and left as stage0 wrote it.   │
# └──────────────────────────────────────────────────────────────────────┘
#
# WORK_DIR is the ROOT's, not the package's: depend.mk passes it through
# $(ENV), directories.mk keeps what it is handed (ifndef). One tc_vars.mk per
# tree, and the `env -i` at an spk meta source is where the next one starts.
#
# tc_vars.mk and nothing else: the other files embed INSTALL_PREFIX-derived
# paths, and INSTALL_PREFIX is recipe environment $(shell) cannot see at parse.
# Writing them here bakes in /usr/local and breaks every cmake dependant.
#
# Guards: ARCH non-noarch AND TCVERSION both required, or a sub-make carrying
# one alone derives a bogus syno--<vers> path; skipped inside toolchain/ for
# recursion -- do NOT guard on $(TC), spk.mk sets it before common.mk.
#
# Gotchas: never pass MSG= to the sub-make, a blank one turns recipe message
# lines into shell commands. Its stdout goes to `>&2` so $(shell), which reads
# fd 1 only, keeps the build output out of the parse yet on console and in logs.
#
###############################################################################

ifneq ($(strip $(filter-out noarch,$(ARCH))),)
ifneq ($(strip $(TCVERSION)),)
ifeq ($(filter toolchain,$(subst /, ,$(CURDIR))),)

# Inside the "not in toolchain dir" guard so a toolchain build keeps its own
# definitions: TC_WORK_DIR is `?=` there and would hold our bogus syno--/work.
TC_WORK_DIR := $(abspath $(BASEDIR)/toolchain/syno-$(ARCH)-$(TCVERSION)/work)

# Unconditional and ahead of pre-check, so a refused arch still leaves one behind. The
# overlay switches go on the command line -- overlay.mk's export does not reach a $(shell).
# MAKEFLAGS cleared: a $(shell) sub-make inherits -n/-p and would print, not write.
ifeq ($(wildcard $(WORK_DIR)/tc_vars.mk),)
  $(shell mkdir -p $(WORK_DIR))
  $(shell MAKEFLAGS= $(MAKE) WORK_DIR=$(WORK_DIR) $(FWRD_ARGS) --no-print-directory -C $(BASEDIR)/toolchain/syno-$(ARCH)-$(TCVERSION) tcvars-identity >/dev/null 2>&1)
endif

# Load toolchain-identity variables for the parse (TC_GCC, TC_VERS, ...)
-include $(WORK_DIR)/tc_vars.mk

# Keyed on the extracted $(TC_TARGET), the toolchain no longer generating a file to
# look for. The cookie traces who paid for it; it guards nothing.
ifeq ($(filter-out dependency-%,$(MAKECMDGOALS)),)
ifeq ($(wildcard $(TC_WORK_DIR)/$(TC_TARGET)),)
  $(info ===> Bootstrapping toolchain for $(ARCH)-$(TCVERSION) (stage0))
  $(shell $(MAKE) WORK_DIR=$(TC_WORK_DIR) --no-print-directory -C $(BASEDIR)/toolchain/syno-$(ARCH)-$(TCVERSION) toolchain >&2 && touch $(WORK_DIR)/.stage0-bootstrap_done)
endif
endif

endif
endif
endif
