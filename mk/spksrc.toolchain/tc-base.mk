###############################################################################
# spksrc.toolchain/tc-base.mk
#
# Defines core toolchain identity and versioning variables.
#
# This file:
#  - derives toolchain metadata from TC_VERS when not explicitly set
#
# Variables:
#  TC_NAME        : Toolchain name (default: syno-$(TC_ARCH))
#  TC_TYPE        : Toolchain type (DSM/SRM)
#  TC_BUILD       : Synology DSM/SRM build number
#  TC_OS_MIN_VER  : Minimum supported OS version (<major>.<minor>-<build>)
#
# Notes:
#  - TC_VERS is the authoritative input from toochain/syno-*/Makefile
#
###############################################################################

ifeq ($(strip $(TC_NAME)),)
TC_NAME = syno-$(TC_ARCH)
endif

ifeq ($(strip $(TC_TYPE)),)
TC_TYPE = $(call toolchain-type,$(TC_VERS))
endif

ifeq ($(strip $(TC_BUILD)),)
TC_BUILD = $(call toolchain-build,$(TC_VERS))
endif

ifeq ($(strip $(TC_OS_MIN_VER)),)
TC_OS_MIN_VER = $(word 1,$(subst ., ,$(TC_VERS))).$(word 2,$(subst ., ,$(TC_VERS)))-$(TC_BUILD)
endif
