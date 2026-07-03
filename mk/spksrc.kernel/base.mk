###############################################################################
# spksrc.kernel/base.mk
#
# Defines default kernel environment variables.
#
# This file:
#  - derives toolchain work directory path
#  - defines default kernel naming convention
#  - sets default kernel configuration file
#  - initializes optional kernel packaging parameters
#
# Variables:
#
#   TC_WORK_DIR     Absolute path to toolchain work directory
#                   ($(WORK_DIR)/../../../toolchain/$(TC)/work)
#   KERNEL_NAME     Default: syno-$(KERNEL_VERS)
#   KERNEL_TYPE     Kernel type (DSM/SRM)
#   KERNEL_BUILD    Synology DSM/SRM build number
#   KERNEL_CONFIG   Default: synoconfigs/$(KERNEL_ARCH)
#   KERNEL_PREFIX   Default: $(KERNEL_DIST)
#   KERNEL_STRIP    Strip kernel modules (0 = disabled, default)
#
# Notes:
#
#  - All variables except TC_WORK_DIR may be overridden before inclusion.
#  - Defaults are only applied when variables are unset or empty.
#
###############################################################################

TC_WORK_DIR=$(abspath $(WORK_DIR)/../../../toolchain/$(TC)/work)

ifeq ($(strip $(KERNEL_NAME)),)
KERNEL_NAME = syno-$(KERNEL_ARCH)
endif

ifeq ($(strip $(KERNEL_TYPE)),)
KERNEL_TYPE = $(call kernel-type,$(KERNEL_VERS))
endif

ifeq ($(strip $(KERNEL_BUILD)),)
KERNEL_BUILD = $(call kernel-build,$(KERNEL_VERS))
endif

ifeq ($(strip $(KERNEL_CONFIG)),)
KERNEL_CONFIG = synoconfigs/$(KERNEL_ARCH)
endif

ifeq ($(strip $(KERNEL_PREFIX)),)
KERNEL_PREFIX = $(KERNEL_DIST)
endif

ifeq ($(strip $(KERNEL_STRIP)),)
KERNEL_STRIP = 0
endif
