ifeq ($(strip $(KERNEL_NAME)),)
KERNEL_NAME = syno-$(KERNEL_ARCH)-$(KERNEL_VERS)
endif

ifeq ($(strip $(KERNEL_EXT)),)
KERNEL_EXT = txz
endif
 
ifeq ($(strip $(KERNEL_DIST_FILE)),)
KERNEL_DIST_FILE = $(KERNEL_ARCH)-$(KERNEL_DIST).$(KERNEL_EXT)
endif

# For DSM version >= 6.1
ifeq ($(shell expr "$(KERNEL_BUILD)" \>= 15152),1)
ifeq ($(strip $(KERNEL_DIST_NAME)),)
KERNEL_DIST_NAME = $(KERNEL_DIST).$(KERNEL_EXT)
endif
 
ifeq ($(strip $(KERNEL_URL_DIR)),)
KERNEL_URL_DIR = $(KERNEL_ARCH)-source
endif

ifeq ($(strip $(KERNEL_PREFIX)),)
KERNEL_PREFIX = $(KERNEL_DIST)
endif

ifeq ($(strip $(KERNEL_STRIP)),)
KERNEL_STRIP = 0
endif

# For DSM version = 5.2
else ifeq ($(shell expr "$(KERNEL_BUILD)" \>= 5565),1)
ifeq ($(strip $(KERNEL_DIST_NAME)),)
KERNEL_DIST_NAME = $(KERNEL_ARCH)-source.$(KERNEL_EXT)
endif

ifeq ($(strip $(KERNEL_URL_DIR)),)
KERNEL_URL_DIR = /
endif

ifeq ($(strip $(KERNEL_PREFIX)),)
KERNEL_PREFIX = source/$(KERNEL_DIST)
endif

ifeq ($(strip $(KERNEL_STRIP)),)
KERNEL_STRIP = 1
endif

# For DSM version <= 5.1
else ifeq ($(shell expr "$(KERNEL_BUILD)" \<= 5004),1)
ifeq ($(strip $(KERNEL_DIST_NAME)),)
KERNEL_DIST_NAME = synogpl-$(KERNEL_BUILD)-$(KERNEL_ARCH).$(KERNEL_EXT)
endif

ifeq ($(strip $(KERNEL_URL_DIR)),)
KERNEL_URL_DIR = /
endif

ifeq ($(strip $(KERNEL_PREFIX)),)
KERNEL_PREFIX = source/$(KERNEL_DIST)
endif

ifeq ($(strip $(KERNEL_STRIP)),)
KERNEL_STRIP = 1
endif
endif

ifeq ($(strip $(KERNEL_DIST_SITE)),)
KERNEL_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Synology%20NAS%20GPL%20Source/$(KERNEL_BUILD)branch/$(KERNEL_URL_DIR)
endif

ifeq ($(strip $(KERNEL_CONFIG)),)
KERNEL_CONFIG = synoconfigs/$(KERNEL_ARCH)
endif
