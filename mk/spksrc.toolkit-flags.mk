ifeq ($(strip $(TOOLKIT_NAME)),)
TOOLKIT_NAME = syno-$(TOOLKIT_ARCH)
endif

ifeq ($(strip $(TOOLKIT_DIST)),)
TOOLKIT_DIST = ds.$(TOOLKIT_ARCH)-$(TOOLKIT_VERS).dev
endif

ifeq ($(strip $(TOOLKIT_EXT)),)
TOOLKIT_EXT = txz
endif
 
ifeq ($(strip $(TOOLKIT_DIST_NAME)),)
TOOLKIT_DIST_NAME = $(TOOLKIT_DIST).$(TOOLKIT_EXT)
endif

ifeq ($(strip $(TOOLKIT_DIST_SITE)),)
TOOLKIT_DIST_SITE = https://global.synologydownload.com/download/ToolChain/toolkit/$(TOOLKIT_VERS)/$(TOOLKIT_ARCH)
endif

ifeq ($(strip $(TOOLKIT_PREFIX)),)
TOOLKIT_PREFIX = local
endif

ifeq ($(strip $(TOOLKIT_STRIP)),)
TOOLKIT_STRIP = 5
endif

ifeq ($(strip $(TOOLKIT_BASE_DIR)),)
TOOLKIT_BASE_DIR = $(TOOLKIT_TARGET)
else ifeq ($(strip $(TOOLKIT_BASE_DIR)),nop)
TOOLKIT_BASE_DIR = 
endif

ifeq ($(strip $(TOOLKIT_SYSROOT)),)
TOOLKIT_SYSROOT = sys-root
endif

ifeq ($(strip $(TOOLKIT_SYSROOT_PATH)),)
TOOLKIT_SYSROOT_PATH ?= $(TOOLKIT_BASE_DIR)/$(TOOLKIT_SYSROOT)/usr
else ifeq ($(strip $(TOOLKIT_SYSROOT_PATH)),nop)
TOOLKIT_SYSROOT_PATH = 
endif
