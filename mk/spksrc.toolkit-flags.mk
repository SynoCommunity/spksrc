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
TOOLKIT_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/toolkit/DSM$(TOOLKIT_VERS)
endif

ifeq ($(strip $(TOOLKIT_PREFIX)),)
TOOLKIT_PREFIX = local
endif

ifeq ($(strip $(TOOLKIT_STRIP)),)
TOOLKIT_STRIP = 6
endif

ifeq ($(strip $(TOOLKIT_BASE_DIR)),)
TOOLKIT_BASE_DIR = $(TOOLKIT_TARGET)
else ifeq ($(strip $(TOOLKIT_BASE_DIR)),nop)
TOOLKIT_BASE_DIR = 
endif

ifeq ($(strip $(TOOLKIT_SYSROOT)),)
TOOLKIT_SYSROOT ?= $(TOOLKIT_BASE_DIR)/sys-root/usr
else ifeq ($(strip $(TOOLKIT_SYSROOT)),nop)
TOOLKIT_SYSROOT = 
endif
