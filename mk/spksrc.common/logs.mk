###############################################################################
# spksrc.common/logs.mk
#
# Defines logging-related variables and helpers for spksrc builds.
#
# This file:
#  - defines standard build log file locations
#  - provides terminal color escape sequences for log output
#  - enables optional build timing and status logging
#
# Variables:
#  RED            : terminal escape sequence for red text
#  GREEN          : terminal escape sequence for green text
#  NC             : terminal escape sequence to reset formatting
#
#  DEFAULT_LOG    : default build log file (per arch/DSM where that applies:
#                   toolchain, toolkit, kernel, and native-toolchain packages)
#  CROSSENV_LOG   : cross-environment build log file
#  WHEEL_LOG      : Python wheel build log file
#  STATUS_LOG     : aggregated build status and timing log
#
#  PSTAT_TIME     : time(1) wrapper for parallel build statistics
#
# Notes:
#  - Terminal color variables rely on tput(1)
#  - PSTAT_TIME is enabled only when PSTAT is set to 1 or ON
#
###############################################################################

# Terminal colors
RED=$$(tput setaf 1)
GREEN=$$(tput setaf 2)
NC=$$(tput sgr0)

# STATUS_ARCH is the arch label of the current build context: it names the log
# file below and is what status.mk and the LOG_WRAPPED failure message report in
# their ARCH column, so the two can never disagree.
ifeq ($(notdir $(abspath $(CURDIR)/..)),toolchain)
  STATUS_ARCH = $(or $(lastword $(subst -, ,$(TC_NAME))),$(TC_ARCH))-$(TC_VERS)
else ifeq ($(notdir $(abspath $(CURDIR)/..)),toolkit)
  STATUS_ARCH = $(or $(lastword $(subst -, ,$(TK_NAME))),$(TK_ARCH))-$(TK_VERS)
else ifeq ($(notdir $(abspath $(CURDIR)/..)),kernel)
  STATUS_ARCH = $(KERNEL_ARCH)-$(KERNEL_VERS)
else ifeq ($(notdir $(abspath $(CURDIR)/..)),native)
  # Derived from WORK_DIR, which is what actually distinguishes the two kinds of
  # native package (TC_ARCH is unusable here: it is also set in kernel/spk builds).
  # A native-toolchain package (gcc8, binutils-*) builds one (arch, DSM) per
  # work-<arch>-<vers> dir -> <arch>-<vers>, same shape as a toolchain build; a
  # plain native package (work-native) collapses to plain "native".
  STATUS_ARCH = $(patsubst work-%,%,$(notdir $(WORK_DIR)))
else
  STATUS_ARCH = $(ARCH)-$(TCVERSION)
endif

ifeq ($(notdir $(abspath $(CURDIR)/..)),toolchain)
  DEFAULT_LOG = $(LOG_DIR)/build-$(STATUS_ARCH).log
else ifeq ($(notdir $(abspath $(CURDIR)/..)),toolkit)
  DEFAULT_LOG = $(LOG_DIR)/build-$(STATUS_ARCH).log
else ifeq ($(notdir $(abspath $(CURDIR)/..)),kernel)
  DEFAULT_LOG = $(LOG_DIR)/build-$(STATUS_ARCH).log
else ifeq ($(notdir $(abspath $(CURDIR)/..)),native)
  DEFAULT_LOG = $(LOG_DIR)/build-$(STATUS_ARCH).log
else
  DEFAULT_LOG = $(LOG_DIR)/build$(or $(ARCH_SUFFIX),-noarch-$(TCVERSION)).log
endif
CROSSENV_LOG = $(LOG_DIR)/build$(ARCH_SUFFIX)-crossenv.log
WHEEL_LOG    = $(LOG_DIR)/build$(ARCH_SUFFIX)-wheel.log
STATUS_LOG   = $(LOG_DIR)/status-build.log

# Enable stats over parallel build mode
ifneq ($(filter 1 on ON,$(PSTAT)),)
PSTAT_TIME = time -o $(STATUS_LOG) --append --quiet
endif
