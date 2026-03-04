###############################################################################
# spksrc.cross-cc.mk
#
# Provides the main cross-compilation entry point for spksrc dependencies.
#
# This makefile orchestrates a two-stage build process:
#
#   Stage 1: Toolchain bootstrap
#     - Ensures the toolchain for the target architecture exists
#     - Generates all tc_vars* files in $(WORK_DIR)
#
#   Stage 2: Package cross-compilation
#     - Sets up the cross-compilation environment
#     - Executes the standard spksrc build pipeline:
#         download → extract → patch → configure → compile → install → plist
#
# Stage separation guarantees that:
#   - The toolchain is fully built before any package logic runs
#   - tc_vars* files are generated exactly once and reused
#
# Main targets:
#   cross-stage1 : Builds toolchain and generates tc_vars*
#   cross-stage2 : Builds the package using cross-env
#   all          : Runs both stages with logging
#
# Variables:
#   TC               : Toolchain identifier (syno-<arch>-<tcversion>)
#   TC_WORK_DIR      : Toolchain working directory
#   TCVARS_DONE      : Cookie indicating tc_vars generation completed
#   TK               : Toolkit identifier (syno-<arch>-<tcversion>)
#   TK_WORK_DIR      : Toolkit working directory
#   TKVARS_DONE      : Cookie indicating tk_vars generation completed
#
# Notes:
#   - This file is the canonical entry point for cross builds.
#   - cross-env.mk consumes tc_vars* generated during Stage1.
#   - Logging is centralized via LOG_WRAPPED for consistent output.
#
###############################################################################
# Cross-compilation orchestration overview
#
# This makefile provides a two-stage cross-compilation pipeline.
#
# ┌──────────────────────────────────────────────────────────────────────┐
# │                          cross-stage1                                │
# │  (toolchain bootstrap & environment materialization)                 │
# │                                                                      │
# │   make -C toolchain/<TC> toolchain  (MANDATORY)                      │
# │   make -C toolchain/<TC> toolkit    (OPTIONAL)                       │
# └──────────────────────────────────────────────────────────────────────┘
#                                  │
#                                  │ (cookie exists)
#                                  ▼
# ┌──────────────────────────────────────────────────────────────────────┐
# │                          cross-stage2                                │
# │  (package build using cross-env)                                     │
# │                                                                      │
# │   spksrc.cross/env-default.mk                                        │
# │        │                                                             │
# │        ├─ loads tc_vars.mk (always)                                  │
# │        ├─ loads tc_vars.<env>.mk based on DEFAULT_ENV                │
# │        ├─ exports TC_ENV into ENV                                    │
# │        │                                                             │
# │        └─ loads tk_vars.mk (optional)                                │
# │                                                                      │
# │   Standard spksrc pipeline:                                          │
# │     depend → configure → compile → install → plist                   │
# └──────────────────────────────────────────────────────────────────────┘
#
# Notes:
#  - cross-stage1 is idempotent (guarded by .tcvars_done and .tkvars_done)
#  - cross-stage2 never builds the toolchain nor toolkit
#  - toolchain and toolkit package builds are strictly separated
###############################################################################


# Variables
URLS          = $(PKG_DIST_SITE)/$(PKG_DIST_NAME)
NAME          = $(PKG_NAME)
COOKIE_PREFIX = $(PKG_NAME)-
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
ifeq ($(strip $(REQUIRE_TOOLKIT)),1)
TK = $(TC)
endif
endif
endif

.DEFAULT_GOAL := all

# Common directories (must be set after ARCH_SUFFIX)
include ../../mk/spksrc.common/directories.mk

# Common makefiles
include ../../mk/spksrc.common.mk

#####

include ../../mk/spksrc.rules/pre-check.mk

include ../../mk/spksrc.cross/env-default.mk

include ../../mk/spksrc.build/download.mk

include ../../mk/spksrc.rules/depend.mk

include ../../mk/spksrc.rules/status.mk

checksum: download
include ../../mk/spksrc.build/checksum.mk

extract: checksum depend status
include ../../mk/spksrc.build/extract.mk

patch: extract
include ../../mk/spksrc.build/patch.mk

configure: patch
include ../../mk/spksrc.build/configure.mk

compile: configure
include ../../mk/spksrc.build/compile.mk

install: compile
include ../../mk/spksrc.build/install.mk

plist: install
include ../../mk/spksrc.build/plist.mk

#####

# -----------------------------------------------------------------------------
# Stage1: Toolchain (MANDATORY) + Toolkit (OPTIONAL) bootstrap
#  - First call builds the toolchain / toolkit (download / extract / patch / build)
#  - Second call generates tc_vars* and tk_vars.mk files in the package WORK_DIR
# -----------------------------------------------------------------------------
TCVARS_DONE := $(WORK_DIR)/.tcvars_done
TKVARS_DONE := $(WORK_DIR)/.tkvars_done

.PHONY: cross-stage1
cross-stage1: $(TCVARS_DONE) $(TKVARS_DONE)

ifneq ($(strip $(TC)),)
$(TCVARS_DONE):
	@$(MAKE) WORK_DIR=$(TC_WORK_DIR) --no-print-directory -C ../../toolchain/$(TC) toolchain
	@$(MAKE) WORK_DIR=$(WORK_DIR) --no-print-directory -C ../../toolchain/$(TC) tcvars
else
$(TCVARS_DONE): ;
endif

# $(TK) is only being set if REQUIRE_TOOLKIT=1
ifneq ($(strip $(TK)),)
$(TKVARS_DONE):
	@$(MAKE) WORK_DIR=$(TK_WORK_DIR) --no-print-directory -C ../../toolkit/$(TK) toolkit
	@$(MAKE) WORK_DIR=$(WORK_DIR) --no-print-directory -C ../../toolkit/$(TK) tkvars
else
$(TKVARS_DONE): ;
endif

# -----------------------------------------------------------------------------
# Stage2: Package cross build
#  - Relies on cross-env.mk for environment setup
#  - Executes full build pipeline up to plist generation
# -----------------------------------------------------------------------------
.PHONY: cross-stage2
cross-stage2: install plist

# all wraps both stages with logging to ensure:
#  - consistent output formatting
#  - proper error propagation
.PHONY: all
all:
	@mkdir -p $(WORK_DIR)
	$(call LOG_WRAPPED,cross-stage1)
	$(call LOG_WRAPPED,cross-stage2)

####

### For arch-* and all-<supported|latest>
include ../../mk/spksrc.rules/supported.mk

####
