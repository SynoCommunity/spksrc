###############################################################################
# spksrc.common.mk
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
#       ├── stage0.mk  : bootstrap toolchain & load its tc_vars (TC_GCC, ...)
#       ├── archs.mk   : architecture and toolchain classification
#       ├── logs.mk    : build log paths and logging helpers
#       └── macros.mk  : generic GNU Make helper macros
#
###############################################################################

# Determine MKDIR from this file's own location in MAKEFILE_LIST, regardless
# of CURDIR or the caller's directory structure (works under github-action
# where the workspace root may differ from the spksrc directory name).
# MKDIR must use := for immediate evaluation before any further includes
# alter MAKEFILE_LIST. BASEDIR uses ?= to allow override from the command line.
MKDIR  := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
BASEDIR ?= $(abspath $(MKDIR)/..)

ifneq ($(ARCH),)
ARCH_SUFFIX = -$(ARCH)-$(TCVERSION)
endif

# Utility variables
empty :=
space := $(empty) $(empty)
# For literal ',' in $(eval ...) contexts interpreted as individual arguments -> $(eval -Wl$(,)--rpath-link$(,)/some/path)
, := ,

# Ahead of every include below, not further down the file: an included makefile that uses
# these in a `:=` assignment expands them at its own parse, and would otherwise get empty.
# Load macros early
include $(BASEDIR)/mk/spksrc.common/macros.mk

# Common directories (must be set after ARCH_SUFFIX)
include $(BASEDIR)/mk/spksrc.common/directories.mk

# Load local configuration
LOCAL_CONFIG_MK = $(BASEDIR)/local.mk
-include $(LOCAL_CONFIG_MK)

# Hardware video acceleration comes from the synocli-videodriver meta. AFTER local.mk for
# the same reason as the overlay switches, and read like them -- except that only an
# explicit 0/off leaves the meta out, so an unexpected value builds rather than silently
# publishing an ffmpeg with no acceleration and no error to show for it.
VIDEODRV    ?= 1
VIDEODRV_ON  = $(if $(filter 0 off OFF,$(strip $(VIDEODRV))),,1)

# Carried to every crossing: a meta that disagrees links a libdrm its consumer cannot
# resolve, which is the same class of hazard as an overlay's ABI.
FWRD_VARS += VIDEODRV

### Overlay decisions -- AFTER local.mk: both use ?=, so the first read wins and that has
### to be local.mk. Chain: command line > environment > local.mk > these defaults.
include $(BASEDIR)/mk/spksrc.common/overlay.mk

# The switches named above, as command-line variables. Here and not lower down: stage0's
# $(shell) below is the first crossing to read them.
FWRD_ARGS = $(foreach v,$(sort $(FWRD_VARS)),$(v)='$($(v))')

# One asks for debug symbols, the other strips them. env-default.mk lets the first win by
# if/else, while cmake, ninja and install test the second on its own and still strip.
ifneq ($(and $(filter 1,$(strip $(GCC_DEBUG_INFO))),$(filter 1,$(strip $(GCC_NO_DEBUG_INFO)))),)
$(error GCC_DEBUG_INFO and GCC_NO_DEBUG_INFO are mutually exclusive -- set one or neither)
endif

# Setup minimal toolchain environment variables -- AFTER overlay.mk and FWRD_ARGS above,
# so the tc_vars.mk stage0 writes already carries this build's switches.
include $(BASEDIR)/mk/spksrc.common/stage0.mk

# Load common definitions
include $(BASEDIR)/mk/spksrc.common/archs.mk

# Which archs a dotnet package refuses (needs the arch groups above)
include $(BASEDIR)/mk/spksrc.common/dotnet.mk

include $(BASEDIR)/mk/spksrc.common/logs.mk

### Toolchain capabilities -- AFTER overlay.mk: TC_RUSTC depends on whether the rust
### overlay is active, and the MIN_RUSTC_VERSION floor has to agree with it.
include $(BASEDIR)/mk/spksrc.common/tc-capability.mk

###

# all will be the default target, regardless of what is defined
default: all

# Context-aware `make help` (only activates inside a package directory).
# Included after 'default: all' so the help target never becomes the default
# goal (it would otherwise shadow the build when running e.g. `make` or a
# recursive arch build).
include $(BASEDIR)/mk/spksrc.common/help.mk

# Stop on first error
SHELL := $(SHELL) -e

# For legacy reasons keep $(PWD) call
PWD := $(CURDIR)

# Launch command in the working dir of the package source and the right environment
RUN = cd $(WORK_DIR)/$(PKG_DIR) && env $(ENV)

# Display message in a consistent way
MSG = echo "===> "

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
