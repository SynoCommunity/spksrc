###############################################################################
# spksrc.toolchain.mk
#
# This makefile provides the complete toolchain build logic for spksrc.
# It is responsible for:
#  - downloading and extracting the toolchain
#  - verifying checksums
#  - applying normalization and patches
#  - installing additional compiler components (rust)
#  - resolving toolchain dependencies
#  - generating tc_vars* files used by cross-compilation environments
#
# The toolchain build is organized as a staged pipeline with overridable
# pre/post hooks and a persistent status cookie.
#
# Targets are executed in the following order:
#  toolchain_msg
#  pre_toolchain_target    (override with PRE_TOOLCHAIN_TARGET)
#  toolchain_target        (override with TOOLCHAIN_TARGET)
#  post_toolchain_target   (override with POST_TOOLCHAIN_TARGET)
#
# The actual work is performed by the internal target:
#  _all
#
# which executes:
#  status      : echo status to logging facility
#  rustc       : install rust toolchain components
#  depend      : resolve and build toolchain dependencies (if any)
#  tcvars      : generate tc_vars*.mk files for spksrc.cross/env-default.mk
#
# Variables:
#  TC_NAME           : Toolchain name (optional, used with generic archs)
#  TC_ARCH           : Target architecture (fallback if TC_NAME unset)
#  TC_VERS           : Toolchain DSM version
#  TC                : Fully qualified toolchain identifier (syno-<arch>-<vers>)
#  TC_WORK_DIR       : Toolchain working directory
#  TOOLCHAIN_COOKIE  : Status cookie indicating toolchain build completion
#
# Files:
#  $(TC_WORK_DIR)/.$(COOKIE_PREFIX)toolchain_done
#                     Marks successful completion of the toolchain build
#  $(WORK_DIR)/tc_vars*.mk
#                     Generated toolchain environment definitions used by
#                     cross-env.mk and package builds
#
# Notes:
#  - The toolchain target is idempotent: if the cookie exists, it is skipped.
#  - Logging is centralized via LOG_WRAPPED and applied to the full build.
#  - This makefile orchestrates modular logic implemented under
#    mk/spksrc.toolchain/.
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
# │   make -C toolchain/<TC> toolchain                                   │
# │        │                                                             │
# │        ▼                                                             │
# │   [ toolchain build ]                                                │
# │        │                                                             │
# │        ├─ downloads / patches / rust / deps                          │
# │        └─ generates tc_vars* files                                   │
# │             │                                                        │
# │             ├─ tc_vars.mk                (core toolchain identity)   │
# │             ├─ tc_vars.autotools.mk      (autotools adapter)         │
# │             ├─ tc_vars.flags.mk          (C/C++ flags)               │
# │             ├─ tc_vars.rust.mk            (Rust env)                 │
# │             ├─ tc_vars.cmake              (CMake toolchain file)     │
# │             └─ tc_vars.meson-*            (Meson cross/native files) │
# │                                                                      │
# │   creates status cookie: $(WORK_DIR)/.tcvars_done                    │
# └──────────────────────────────────────────────────────────────────────┘
#                                  │
#                                  │ (cookie exists)
#                                  ▼
# ┌──────────────────────────────────────────────────────────────────────┐
# │                          cross-stage2                                │
# │  (package build using cross-env)                                     │
# └──────────────────────────────────────────────────────────────────────┘
#
# Notes:
#  - cross-stage1 is idempotent (guarded by .tcvars_done)
#  - cross-stage2 never builds the toolchain
#  - toolchain and package builds are strictly separated
###############################################################################

# Variables
URLS                       = $(TC_DIST_SITE)/$(TC_DIST_NAME)
NAME                       = $(TC_NAME)
COOKIE_PREFIX              = toolchain-
ifneq ($(strip $(TC_DIST_FILE)),)
LOCAL_FILE                 = $(TC_DIST_FILE)
# download.mk uses PKG_DIST_FILE
PKG_DIST_FILE              = $(TC_DIST_FILE)
else
LOCAL_FILE                 = $(TC_DIST_NAME)
endif
DISTRIB_DIR                = $(TOOLCHAIN_DIR)/$(TC_VERS)
DIST_FILE                  = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT                   = $(TC_EXT)

ifneq ($(strip $(or $(TC_NAME),$(TC_ARCH))),)
TC_ARCH_SUFFIX = -$(or $(lastword $(subst -, ,$(TC_NAME))),$(TC_ARCH))-$(TC_VERS)
else
TC_ARCH_SUFFIX :=
endif

#####

# Common directories
include ../../mk/spksrc.common/directories.mk

### Include common definitions
include ../../mk/spksrc.common.mk

### Include common rules
include ../../mk/spksrc.rules.mk

#####

# Mark toolchain installation as completed using status cookie
TOOLCHAIN_COOKIE = $(TC_WORK_DIR)/.$(COOKIE_PREFIX)toolchain_done

TC = syno$(TC_ARCH_SUFFIX)
TC_WORK_DIR ?= $(abspath $(WORK_DIR)/../../../toolchain/$(TC)/work)

# Define $(RUN) for other targets (download, extract, patch, etc)
RUN = cd $(TC_WORK_DIR)/$(TC_TARGET) && env $(ENV)

#####

.PHONY: $(PRE_TOOLCHAIN_TARGET) $(TOOLCHAIN_TARGET) $(POST_TOOLCHAIN_TARGET)
ifeq ($(strip $(PRE_TOOLCHAIN_TARGET)),)
PRE_TOOLCHAIN_TARGET = pre_toolchain_target
else
$(PRE_TOOLCHAIN_TARGET): toolchain_msg
endif
ifeq ($(strip $(TOOLCHAIN_TARGET)),)
TOOLCHAIN_TARGET = toolchain_target
else
$(TOOLCHAIN_TARGET): $(PRE_TOOLCHAIN_TARGET)
endif
ifeq ($(strip $(POST_TOOLCHAIN_TARGET)),)
POST_TOOLCHAIN_TARGET = post_toolchain_target
else
$(POST_TOOLCHAIN_TARGET): $(TOOLCHAIN_TARGET)
endif

#####

include ../../mk/spksrc.rules/depend.mk

include ../../mk/spksrc.toolchain/tc-base.mk
include ../../mk/spksrc.toolchain/tc-flags.mk
include ../../mk/spksrc.toolchain/tc-url.mk
include ../../mk/spksrc.toolchain/tc-versions.mk

include ../../mk/spksrc.rules/status.mk

download:
include ../../mk/spksrc.build/download.mk

checksum: download
include ../../mk/spksrc.build/checksum.mk

extract: checksum
include ../../mk/spksrc.build/extract.mk

normalize: extract
include ../../mk/spksrc.toolchain/tc-normalize.mk

patch: normalize
include ../../mk/spksrc.build/patch.mk

rustc: patch
include ../../mk/spksrc.toolchain/tc-rust.mk

include ../../mk/spksrc.toolchain/tc_vars.mk

#####

.DEFAULT_GOAL := toolchain

.PHONY: toolchain_msg
toolchain_msg:
	@$(MSG) "Preparing toolchain for $(or $(lastword $(subst -, ,$(TC_NAME))),$(TC_ARCH))-$(TC_VERS)"

pre_toolchain_target: toolchain_msg

# Define _all as a real target that does the work
.PHONY: _all
_all: status rustc depend tcvars

# toolchain_target wraps _all with logging
.PHONY: toolchain_target
toolchain_target: $(PRE_TOOLCHAIN_TARGET)
	$(call LOG_WRAPPED,_all)

post_toolchain_target: $(TOOLCHAIN_TARGET)

#####

ifeq ($(wildcard $(TOOLCHAIN_COOKIE)),)
toolchain: $(TOOLCHAIN_COOKIE)

$(TOOLCHAIN_COOKIE): $(POST_TOOLCHAIN_TARGET)
	$(create_target_dir)
	@touch -f $@

else
toolchain: ;
endif

### For make digests
include ../../mk/spksrc.rules/generate-digests.mk
