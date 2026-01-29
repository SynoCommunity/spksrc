###############################################################################
# mk/spksrc.common.mk
#
# Defines common build settings and utilities shared by all spksrc makefiles.
#
# This file:
#  - establishes the base directory for the build environment
#  - loads shared architecture, logging, and macro definitions
#  - loads optional local configuration overrides (local.mk)
#  - defines common build helpers and default targets
#  - configures parallel build behavior
#
# Variables:
#  BASEDIR        : root directory of the spksrc tree
#  RUN            : helper to execute commands in package build environment
#  MSG            : standardized build message prefix
#  LANGUAGES      : supported localization languages
#
#  PARALLEL_MAKE  : parallel build mode (nop / max / N)
#  NCPUS          : number of CPUs used for parallel builds
#
# Targets:
#  default        : alias for the 'all' target
#
# Notes:
#  - Parallel build mode is auto-detected unless explicitly set
#  - This file is intended to be the single entry point for common build definitions
#
# Common include structure:
#
#   mk/spksrc.common.mk
#   └── mk/spksrc.common/
#       ├── archs.mk   : architecture and toolchain classification
#       ├── logs.mk    : build log paths and logging helpers
#       └── macros.mk  : generic GNU Make helper macros
#
###############################################################################

# Set basedir in case called from spkrc/ or from normal sub-dir
# Note that github-action uses workspace/ in place of spksrc/
ifeq ($(BASEDIR),)
ifeq ($(filter spksrc workspace,$(shell basename $(CURDIR))),)
BASEDIR = ../../
endif
endif

# Load common definitions
include $(BASEDIR)mk/spksrc.common/archs.mk
include $(BASEDIR)mk/spksrc.common/logs.mk
include $(BASEDIR)mk/spksrc.common/macros.mk

# Load local configuration
LOCAL_CONFIG_MK = $(BASEDIR)local.mk
ifneq ($(wildcard $(LOCAL_CONFIG_MK)),)
include $(LOCAL_CONFIG_MK)
endif

###

# all will be the default target, regardless of what is defined
default: all

# Stop on first error
SHELL := $(SHELL) -e

# For legacy reasons keep $(PWD) call
PWD := $(CURDIR)

# Launch command in the working dir of the package source and the right environment
RUN = cd $(WORK_DIR)/$(PKG_DIR) && env $(ENV)

# Display message in a consistent way
MSG = echo "===> "

# Define $(empty) and $(space)
empty :=
space := $(empty) $(empty)

# Available languages
LANGUAGES = chs cht csy dan enu fre ger hun ita jpn krn nld nor plk ptb ptg rus spn sve trk

###

# Set parallel build mode
ifeq ($(PARALLEL_MAKE),)
# If not set but -j or -l argument passed, must
# manually specify the value of PARALLEL_MAKE
# as otherwise this will create too high load
ifneq ($(strip $(filter -j% -l%, $(shell ps T $$PPID))),)
PARALLEL_MAKE = nop
ENV += PARALLEL_MAKE=nop
# If not set, force max parallel build mode
else
PARALLEL_MAKE = max
ENV += PARALLEL_MAKE=max
endif
endif

# Allow parallel make to be disabled per package
ifeq ($(DISABLE_PARALLEL_MAKE),1)
PARALLEL_MAKE = nop
endif

# Set NCPUS based on PARALLEL_MAKE
ifeq ($(PARALLEL_MAKE),nop)
NCPUS = 1
else ifeq ($(PARALLEL_MAKE),max)
NCPUS = $(shell grep -c ^processor /proc/cpuinfo)
else
NCPUS = $(PARALLEL_MAKE)
endif
