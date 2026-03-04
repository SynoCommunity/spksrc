###############################################################################
# spksrc.toolkit.mk
#
# This makefile provides the complete toolkit build logic for spksrc.
# It is responsible for:
#  - downloading and extracting the toolkit
#  - verifying checksums
#  - applying normalization and patches
#  - resolving toolkit dependencies
#  - generating tk_vars.mk file used by cross-compilation environments
#
# The toolkit build is organized as a staged pipeline with overridable
# pre/post hooks and a persistent status cookie.
#
# Targets are executed in the following order:
#  toolkit_msg
#  pre_toolkit_target    (override with PRE_TOOLKIT_TARGET)
#  toolkit_target        (override with TOOLKIT_TARGET)
#  post_toolkit_target   (override with POST_TOOLKIT_TARGET)
#
# The actual work is performed by the internal target:
#  _all
#
# which executes:
#  status      : echo status to logging facility
#  patch       : normalize and patch extracted toolkit sources
#  depend      : resolve and build toolkit dependencies (if any)
#  tkvars      : generate tk_vars.mk for spksrc.cross/env-default.mk
#
# Variables:
#  TK_NAME           : Toolkit name (optional, used with generic archs)
#  TK_ARCH           : Target architecture (fallback if TK_NAME unset)
#  TK_VERS           : Toolkit DSM version
#  TK                : Fully qualified toolkit identifier (syno-<arch>-<vers>)
#  TK_WORK_DIR       : Toolkit working directory
#  TOOLKIT_COOKIE    : Status cookie indicating toolkit build completion
#
# Files:
#  $(TK_WORK_DIR)/.$(COOKIE_PREFIX)toolkit_done
#                     Marks successful completion of the toolkit build
#  $(WORK_DIR)/tk_vars.mk
#                     Generated toolkit environment definitions used by
#                     cross-env.mk and package builds
#
# Notes:
#  - The toolkit target is idempotent: if the cookie exists, it is skipped.
#  - Logging is centralized via LOG_WRAPPED and applied to the full build.
#  - This makefile orchestrates modular logic implemented under
#    mk/spksrc.toolkit/.
#
###############################################################################

# Variables
URLS                       = $(TK_DIST_SITE)/$(TK_DIST_NAME)
NAME                       = $(TK_NAME)
COOKIE_PREFIX              = toolkit-
ifneq ($(strip $(TK_DIST_FILE)),)
LOCAL_FILE                 = $(TK_DIST_FILE)
# download.mk uses PKG_DIST_FILE
PKG_DIST_FILE              = $(TK_DIST_FILE)
else
LOCAL_FILE                 = $(TK_DIST_NAME)
endif
DISTRIB_DIR                = $(TOOLKIT_DIR)/$(TK_VERS)
DIST_FILE                  = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT                   = $(TK_EXT)

ifneq ($(strip $(or $(TK_NAME),$(TK_ARCH))),)
TK_ARCH_SUFFIX = -$(or $(lastword $(subst -, ,$(TK_NAME))),$(TK_ARCH))-$(TK_VERS)
else
TK_ARCH_SUFFIX :=
endif

#####

# Common directories
include ../../mk/spksrc.common/directories.mk

### Include common definitions
include ../../mk/spksrc.common.mk

### Include common rules
include ../../mk/spksrc.rules.mk

#####

# Mark toolkit installation as completed using status cookie
TOOLKIT_COOKIE = $(TK_WORK_DIR)/.$(COOKIE_PREFIX)toolkit_done

TK = syno$(TK_ARCH_SUFFIX)
TK_WORK_DIR ?= $(abspath $(WORK_DIR)/../../../toolkit/$(TK)/work)

ifeq ($(strip $(TK_PREFIX)),)
TK_PREFIX = usr/local/$(TK_TARGET)
endif

# Define $(RUN) for other targets (download, extract, patkh, etk)
RUN = cd $(TK_WORK_DIR)/$(TK_PREFIX)/$(TK_SYSROOT) && env $(ENV)

#####

.PHONY: $(PRE_TOOLKIT_TARGET) $(TOOLKIT_TARGET) $(POST_TOOLKIT_TARGET)
ifeq ($(strip $(PRE_TOOLKIT_TARGET)),)
PRE_TOOLKIT_TARGET = pre_toolkit_target
else
$(PRE_TOOLKIT_TARGET): toolkit_msg
endif
ifeq ($(strip $(TOOLKIT_TARGET)),)
TOOLKIT_TARGET = toolkit_target
else
$(TOOLKIT_TARGET): $(PRE_TOOLKIT_TARGET)
endif
ifeq ($(strip $(POST_TOOLKIT_TARGET)),)
POST_TOOLKIT_TARGET = post_toolkit_target
else
$(POST_TOOLKIT_TARGET): $(TOOLKIT_TARGET)
endif

#####

include ../../mk/spksrc.rules/depend.mk

include ../../mk/spksrc.toolkit/tk-base.mk
include ../../mk/spksrc.toolkit/tk-flags.mk
include ../../mk/spksrc.toolkit/tk-url.mk
include ../../mk/spksrc.toolkit/tk-versions.mk

include ../../mk/spksrc.rules/status.mk

download:
include ../../mk/spksrc.build/download.mk

checksum: download
include ../../mk/spksrc.build/checksum.mk

extract: checksum
include ../../mk/spksrc.build/extract.mk

normalize: extract
include ../../mk/spksrc.toolkit/tk-normalize.mk

patch: normalize
include ../../mk/spksrc.build/patch.mk

include ../../mk/spksrc.toolkit/tk_vars.mk

#####

.DEFAULT_GOAL := toolkit

.PHONY: toolkit_msg
toolkit_msg:
	@$(MSG) "Preparing toolkit for $(or $(lastword $(subst -, ,$(TK_NAME))),$(TK_ARCH))-$(TK_VERS)"

pre_toolkit_target: toolkit_msg

# Define _all as a real target that does the work
.PHONY: _all
_all: status patch depend tkvars

# toolkit_target wraps _all with logging
.PHONY: toolkit_target
toolkit_target: $(PRE_TOOLKIT_TARGET)
	$(call LOG_WRAPPED,_all)

post_toolkit_target: $(TOOLKIT_TARGET)

#####

ifeq ($(wildcard $(TOOLKIT_COOKIE)),)
toolkit: $(TOOLKIT_COOKIE)

$(TOOLKIT_COOKIE): $(POST_TOOLKIT_TARGET)
	$(create_target_dir)
	@touch -f $@

else
toolkit: ;
endif

### For make digests
include ../../mk/spksrc.rules/generate-digests.mk
