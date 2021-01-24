ifeq ($(strip $(KERNEL_NAME)),)
KERNEL_NAME = syno-$(KERNEL_ARCH)-$(KERNEL_VERS)
endif

ifeq ($(strip $(KERNEL_EXT)),)
KERNEL_EXT = txz
endif
 
ifeq ($(strip $(KERNEL_DIST_NAME)),)
KERNEL_DIST_NAME = $(KERNEL_DIST).$(KERNEL_EXT)
endif
 
ifeq ($(strip $(KERNEL_DIST_FILE)),)
KERNEL_DIST_FILE = $(KERNEL_ARCH)-$(KERNEL_DIST).$(KERNEL_EXT)
endif
 
ifeq ($(strip $(KERNEL_URL_DIR)),)
KERNEL_URL_DIR = $(KERNEL_ARCH)-source
endif

ifeq ($(strip $(KERNEL_DIST_SITE)),)
KERNEL_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Synology%20NAS%20GPL%20Source/$(KERNEL_BUILD)branch/$(KERNEL_URL_DIR)
endif

ifeq ($(strip $(KERNEL_STRIP)),)
KERNEL_STRIP = 0
endif

ifeq ($(strip $(KERNEL_CONFIG)),)
KERNEL_CONFIG = synoconfigs/$(KERNEL_ARCH)
endif
