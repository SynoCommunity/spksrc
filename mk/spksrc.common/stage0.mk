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
# │ stage0  (PARSE time, this file)                                      │
# │                                                                      │
# │   <pkg work dir>/tc_vars.mk missing?                                 │
# │        │                                                             │
# │        ▼                                                             │
# │   make WORK_DIR=<pkg work dir> -C toolchain/<TC> tcvars-identity     │
# │        └─ writes <pkg work dir>/tc_vars.mk  (identity only; needs    │
# │           no extracted toolchain -- all constants of its Makefile)   │
# │        │                                                             │
# │        ▼                                                             │
# │   -include <pkg work dir>/tc_vars.mk  ->  TC_GCC, TC_VERS, ...       │
# │        │                                                             │
# │        ▼                                                             │
# │   DEPENDS parse evaluates version_ge($(TC_GCC),...) correctly        │
# │        │                                                             │
# │        ▼                                                             │
# │   no explicit goal AND <TC work dir>/<TC_TARGET> missing?            │
# │   make WORK_DIR=<TC work dir> -C toolchain/<TC> toolchain            │
# │        └─ download / extract / patch / rust  (cookie-guarded)        │
# │   touch $(WORK_DIR)/.stage0-bootstrap_done   (trace: who triggered)  │
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
# │        -C toolchain/<TC> tcvars    -> the FULL tc_vars* set, and it  │
# │                                       rewrites stage0's tc_vars.mk   │
# │                                       (needs recipe ENV:             │
# │                                        INSTALL_PREFIX)               │
# └──────────────────────────────────────────────────────────────────────┘
#
# WORK_DIR is the ROOT of the build tree, not the package's own: depend.mk passes it down
# through $(ENV) and directories.mk keeps what it is handed (ifndef), so libpng and the
# zlib it pulls in read one tc_vars.mk, in cross/libpng/work-<arch>-<vers>. The `env -i`
# around an spk meta source is where one tree ends and the next begins. The toolchain
# work dir holds NO tc_vars: it is shared by every tree and could hold only one answer.
#
# Why stage0 generates tc_vars.mk and nothing else: the other files embed
# INSTALL_PREFIX-derived paths (CMAKE_FIND_ROOT_PATH, -I/-L staging flags),
# and INSTALL_PREFIX is recipe ENVIRONMENT (depend.mk/spk.mk) that $(shell)
# does not see at parse time. Generating them here would bake in the
# /usr/local default -> every cmake/autotools dependant breaks (libpng
# "Could NOT find ZLIB", IGC "Could NOT find SPIRVLLVMTranslator", ...).
# tc_vars.mk carries no such path, which is what makes it safe here.
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

# The build tree's own tc_vars.mk, in the ROOT's work dir: depend.mk hands WORK_DIR down
# through $(ENV) and directories.mk keeps it (ifndef), so a dependency reads the tree that
# pulled it in. Unconditional and ahead of pre-check, so a refused arch still leaves one.
# Needs no extracted toolchain: the identity values are toolchain/syno-*/Makefile constants.
# MAKEFLAGS cleared -- a $(shell) sub-make inherits -n/-p and would print, not generate.
ifeq ($(wildcard $(WORK_DIR)/tc_vars.mk),)
  $(shell mkdir -p $(WORK_DIR))
  $(shell MAKEFLAGS= $(MAKE) WORK_DIR=$(WORK_DIR) --no-print-directory -C $(BASEDIR)/toolchain/syno-$(ARCH)-$(TCVERSION) tcvars-identity >/dev/null 2>&1)
endif

# Load toolchain-identity variables for the parse (TC_GCC, TC_VERS, ...)
-include $(WORK_DIR)/tc_vars.mk

# Bootstrap (heavy, cookie-guarded) only when no explicit build goal and the toolchain is
# not extracted. The condition is now the extracted $(TC_TARGET) rather than a generated
# file, the toolchain having stopped generating any. The cookie only traces who triggered.
ifeq ($(filter-out dependency-%,$(MAKECMDGOALS)),)
ifeq ($(wildcard $(TC_WORK_DIR)/$(TC_TARGET)),)
  $(info ===> Bootstrapping toolchain for $(ARCH)-$(TCVERSION) (stage0))
  $(shell $(MAKE) WORK_DIR=$(TC_WORK_DIR) --no-print-directory -C $(BASEDIR)/toolchain/syno-$(ARCH)-$(TCVERSION) toolchain >&2 && touch $(WORK_DIR)/.stage0-bootstrap_done)
endif
endif

endif
endif
endif
