
TC_WORK_DIR=$(abspath $(WORK_DIR)/../../../toolchain/$(TC)/work)

ifeq ($(strip $(KERNEL_NAME)),)
KERNEL_NAME = syno-$(KERNEL_ARCH)-$(KERNEL_VERS)
endif

#ifeq ($(strip $(KERNEL_DIST_FILE)),)
#KERNEL_DIST_FILE = $(KERNEL_ARCH)-$(KERNEL_DIST).$(KERNEL_EXT)
#endif

ifeq ($(strip $(KERNEL_CONFIG)),)
KERNEL_CONFIG = synoconfigs/$(KERNEL_ARCH)
endif

ifeq ($(strip $(KERNEL_PREFIX)),)
KERNEL_PREFIX = $(KERNEL_DIST)
endif

ifeq ($(strip $(KERNEL_STRIP)),)
KERNEL_STRIP = 0
endif

# 6.1-6.2
##ifeq ($(strip $(KERNEL_URL_DIR)),)
##KERNEL_URL_DIR = $(KERNEL_ARCH)-source
##endif

#
# SRM
#
###ifeq ($(strip $(KERNEL_DIST_SITE)),)
###KERNEL_DIST_SITE = https://github.com/SynoCommunity/spksrc/releases/download/kernels/srm$(KERNEL_VERS)
###endif

###ifeq ($(strip $(KERNEL_DIST_NAME)),)
###KERNEL_DIST_NAME = $(KERNEL_ARCH)-$(KERNEL_DIST).$(KERNEL_EXT)
###endif
