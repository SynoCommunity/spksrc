###############################################################################
# mk/spksrc.common/stage0.mk
#
# Early toolchain bootstrap: resolves TC_GCC (and TC_VERS, TC_KERNEL, ...)
# BEFORE the package's DEPENDS are parsed, so version_ge($(TC_GCC),...) gated
# dependencies (shaderc, vulkan, numpy, ...) evaluate against a real GCC
# version instead of an empty one on a cold tree. Applies to both cross/ and
# spk/ packages.
#
# ┌──────────────────────────────────────────────────────────────────────┐
# │ stage0  (PARSE time, this file)                                      │
# │                                                                      │
# │   no explicit goal AND <TC work dir>/tc_vars.mk missing?             │
# │        │                                                             │
# │        ▼                                                             │
# │   make WORK_DIR=<TC work dir> -C toolchain/<TC> toolchain            │
# │        ├─ download / extract / patch / rust  (cookie-guarded)        │
# │        └─ generates <TC work dir>/tc_vars*   (toolchain identity)    │
# │   touch $(WORK_DIR)/.stage0-bootstrap_done   (trace: who triggered)  │
# │        │                                                             │
# │        ▼                                                             │
# │   -include <TC work dir>/tc_vars.mk   ->   TC_GCC, TC_VERS, ...      │
# │        │                                                             │
# │        ▼                                                             │
# │   DEPENDS parse evaluates version_ge($(TC_GCC),...) correctly        │
# └──────────────────────────────────────────────────────────────────────┘
#                                  │
#                                  ▼  (recipes run after parse)
# ┌──────────────────────────────────────────────────────────────────────┐
# │ stage1  (RECIPE time, cross-cc.mk / spk.mk) -- NOT made obsolete     │
# │                                                                      │
# │   make -C toolchain/<TC> toolchain -> no-op when stage0 ran; the     │
# │                                       REAL bootstrap on explicit     │
# │                                       goals (stage0 skips those)     │
# │   make WORK_DIR=<pkg work dir> \                                     │
# │        -C toolchain/<TC> tcvars    -> SOLE generator of the package  │
# │                                       $(WORK_DIR)/tc_vars* (needs    │
# │                                       recipe ENV: INSTALL_PREFIX)    │
# └──────────────────────────────────────────────────────────────────────┘
#
# Why stage0 must NOT generate the package $(WORK_DIR)/tc_vars*: those files
# embed INSTALL_PREFIX-derived paths (CMAKE_FIND_ROOT_PATH, -I/-L staging
# flags), and INSTALL_PREFIX is recipe ENVIRONMENT (depend.mk/spk.mk) that
# $(shell) does not see at parse time. Generating them here bakes in the
# /usr/local default and drops .stage1-tcvars_done, so stage1 never fixes
# them -> every cmake/autotools dependant breaks (libpng "Could NOT find
# ZLIB", IGC "Could NOT find SPIRVLLVMTranslator", ...).
#
# Guards: ARCH non-noarch AND TCVERSION both required (a sub-make carrying
# TCVERSION alone would derive a bogus toolchain/syno--<vers> work path and
# attempt to bootstrap it); skipped inside toolchain/ (recursion; do NOT
# guard on $(TC): spk.mk sets it before common.mk); bootstrap only fires on
# empty MAKECMDGOALS (or dependency-%), which is how the real build parses
# packages (supported.mk build-arch-%). Native builds run under `env -i`
# (depend.mk) -> ARCH empty -> excluded.
#
# Gotchas: never pass MSG= to the sub-make (a blank MSG turns recipe message
# lines into shell commands -> Error 127 before anything is extracted). The
# sub-make stdout goes to `>&2`: $(shell) only captures fd 1, so the build
# output stays out of the parse yet remains visible on console and in logs.
#
###############################################################################

ifneq ($(strip $(filter-out noarch,$(ARCH))),)
ifneq ($(strip $(TCVERSION)),)
ifeq ($(filter toolchain,$(subst /, ,$(CURDIR))),)

# Toolchain-namespace vars -- defined INSIDE the "not in toolchain dir" guard so
# they can never clobber spksrc.toolchain.mk's own definitions during a toolchain
# build (there ARCH/TCVERSION are empty -> a bogus syno--/work path; and
# TC_WORK_DIR in particular is `?=` there, so it would keep our wrong value).
TC_WORK_DIR := $(abspath $(BASEDIR)/toolchain/syno-$(ARCH)-$(TCVERSION)/work)

# Bootstrap (heavy, cookie-guarded) only when no explicit build goal and the
# toolchain is not ready. On success, drop a status cookie in the PACKAGE work
# dir tracing WHICH package triggered the early bootstrap. Purely informational:
# the bootstrap condition is the existence of $(TC_WORK_DIR)/tc_vars.mk, not
# this cookie. Cleaned by spkclean (spk.mk) / clean (rm -fr work-*).
ifeq ($(filter-out dependency-%,$(MAKECMDGOALS)),)
ifeq ($(wildcard $(TC_WORK_DIR)/tc_vars.mk),)
  $(info ===> Bootstrapping toolchain for $(ARCH)-$(TCVERSION) (stage0))
  $(shell mkdir -p $(WORK_DIR))
  $(shell $(MAKE) WORK_DIR=$(TC_WORK_DIR) --no-print-directory -C $(BASEDIR)/toolchain/syno-$(ARCH)-$(TCVERSION) toolchain >&2 && touch $(WORK_DIR)/.stage0-bootstrap_done)
endif
endif

# Load toolchain-identity variables for the parse (TC_GCC, TC_VERS, ...)
-include $(TC_WORK_DIR)/tc_vars.mk

endif
endif
endif
