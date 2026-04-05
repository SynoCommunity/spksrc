###############################################################################
# spksrc.toolkit/tk-base.mk
#
# Defines core toolkit identity and versioning variables.
#
# This file:
#  - derives toolkit metadata from TK_VERS when not explicitly set
#
# Variables:
#  TK_NAME        : Toolkit name (default: syno-$(TK_ARCH))
#  TK_TYPE        : Toolkit type (DSM/SRM)
#  TK_BUILD       : Synology DSM/SRM build number
#
# Notes:
#  - TK_VERS is the authoritative input from toolkit/syno-*/Makefile
#
###############################################################################

ifeq ($(strip $(TK_NAME)),)
TK_NAME = syno-$(TK_ARCH)
endif

ifeq ($(strip $(TK_TYPE)),)
TK_TYPE = $(call toolkit-type,$(TK_VERS))
endif

ifeq ($(strip $(TK_BUILD)),)
TK_BUILD = $(call toolkit-build,$(TK_VERS))
endif
