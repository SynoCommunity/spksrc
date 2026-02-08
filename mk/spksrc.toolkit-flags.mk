ifeq ($(strip $(TK_NAME)),)
TK_NAME = syno-$(TK_ARCH)
endif

ifeq ($(strip $(TK_DIST)),)
TK_DIST = ds.$(TK_ARCH)-$(TK_VERS).dev
endif

ifeq ($(strip $(TK_EXT)),)
TK_EXT = txz
endif
 
ifeq ($(strip $(TK_DIST_NAME)),)
TK_DIST_NAME = $(TK_DIST).$(TK_EXT)
endif

ifeq ($(strip $(TK_DIST_SITE)),)
TK_DIST_SITE = https://global.synologydownload.com/download/ToolChain/toolkit/$(TK_VERS)/$(TK_ARCH)
endif

ifeq ($(strip $(TK_PREFIX)),)
TK_PREFIX = local
endif

ifeq ($(strip $(TK_STRIP)),)
TK_STRIP = 5
endif

ifeq ($(strip $(TK_BASE_DIR)),)
TK_BASE_DIR = $(TK_TARGET)
else ifeq ($(strip $(TK_BASE_DIR)),nop)
TK_BASE_DIR = 
endif

ifeq ($(strip $(TK_SYSROOT)),)
TK_SYSROOT = sys-root
endif

ifeq ($(strip $(TK_SYSROOT_PATH)),)
TK_SYSROOT_PATH ?= $(TK_BASE_DIR)/$(TK_SYSROOT)/usr
else ifeq ($(strip $(TK_SYSROOT_PATH)),nop)
TK_SYSROOT_PATH = 
endif
