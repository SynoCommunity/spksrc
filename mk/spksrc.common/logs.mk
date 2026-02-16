###############################################################################
# mk/spksrc.common/logs.mk
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
#  DEFAULT_LOG    : default build log file
#  CROSSENV_LOG   : cross-environment build log file
#  WHEEL_LOG      : Python wheel build log file
#  NATIVE_LOG     : native tool build log file
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

ifeq ($(notdir $(abspath $(CURDIR)/..)),toolchain)
  DEFAULT_LOG = $(LOG_DIR)/build-$(or $(lastword $(subst -, ,$(TC_NAME))),$(TC_ARCH))-$(TC_VERS).log
else ifeq ($(notdir $(abspath $(CURDIR)/..)),toolkit)
  DEFAULT_LOG = $(LOG_DIR)/build-$(or $(lastword $(subst -, ,$(TK_NAME))),$(TK_ARCH))-$(TK_VERS).log
else
  DEFAULT_LOG = $(LOG_DIR)/build$(or $(ARCH_SUFFIX),-noarch-$(TCVERSION)).log
endif
CROSSENV_LOG = $(LOG_DIR)/build$(ARCH_SUFFIX)-crossenv.log
WHEEL_LOG    = $(LOG_DIR)/build$(ARCH_SUFFIX)-wheel.log
NATIVE_LOG   = $(LOG_DIR)/build-native-$(PKG_NAME).log
STATUS_LOG   = $(LOG_DIR)/status-build.log

# Enable stats over parallel build mode
ifneq ($(filter 1 on ON,$(PSTAT)),)
PSTAT_TIME = time -o $(STATUS_LOG) --append --quiet
endif
