###############################################################################
# spksrc.kernel/url.mk
#
# Resolves kernel download locations and filenames.
#
# This file:
#  - derives the kernel base URL from KERNEL_VERSION_MAP metadata
#  - constructs the final download URL and archive name
#  - provides lookup macros used by kernel rules
#
###############################################################################

ifeq ($(strip $(KERNEL_WWW)),)
KERNEL_WWW = $(call kernel-url,$(KERNEL_VERS))
endif

ifeq ($(strip $(KERNEL_DIST_SITE_URL)),)
KERNEL_DIST_SITE_URL = \
  $(if $(filter na,$(KERNEL_WWW)),,\
    https://$(KERNEL_WWW)/$(call kernel-download-url,$(KERNEL_WWW)))
endif

# KERNEL_DIST_SITE_PATH is defined in kernel specific Makefile
ifeq ($(strip $(KERNEL_DIST_SITE)),)
KERNEL_DIST_SITE = $(KERNEL_DIST_SITE_URL)/$(KERNEL_DIST_SITE_PATH)
endif

ifeq ($(strip $(KERNEL_EXT)),)
KERNEL_EXT = txz
endif

# KERNEL_DIST is defined in kernel specific Makefile
ifeq ($(strip $(KERNEL_DIST_NAME)),)
KERNEL_DIST_NAME = $(KERNEL_DIST).$(KERNEL_EXT)
endif

ifeq ($(strip $(KERNEL_DIST_FILE)),)
KERNEL_DIST_FILE = $(KERNEL_ARCH)-$(KERNEL_DIST).$(KERNEL_EXT)
endif

ifeq ($(KERNEL_URL_VERSION),)
KERNEL_URL_VERSION = $(KERNEL_VERS)
endif

ifeq ($(strip $(KERNEL_URL_DIR)),)
KERNEL_URL_DIR = $(KERNEL_ARCH)
endif

####
# Macro definitions

kernel-map = \
  $(strip $(foreach m,$(KERNEL_VERSION_MAP),\
    $(if $(filter $(1):%,$(m)),$(m))))

kernel-build = \
  $(word 2,$(subst :, ,$(call kernel-map,$(1))))

kernel-type = \
  $(word 3,$(subst :, ,$(call kernel-map,$(1))))

kernel-url = \
  $(word 4,$(subst :, ,$(call kernel-map,$(1))))

kernel-download-url = \
  $(strip $(foreach u,$(KERNEL_URL_MAP),\
    $(if $(filter $(1):%,$(u)),\
      $(patsubst $(1):%,%,$(u)))))

KERNEL_URL_MAP = \
    global.synologydownload.com:download/ToolChain/Synology%20NAS%20GPL%20Source/$(KERNEL_URL_VERSION)-$(KERNEL_BUILD)/$(KERNEL_URL_DIR) \
    github.com/SynoCommunity/spksrc:releases/download/kernels/srm$(KERNEL_VERS) \
    sourceforge.net:projects/dsgpl/files/Synology%20NAS%20GPL%20Source/$(KERNEL_BUILD)branch/$(KERNEL_URL_DIR)
