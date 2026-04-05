###############################################################################
# spksrc.toolchain/tc-url.mk
#
# Resolves toolchain download locations and filenames.
#
# This file:
#  - derives the toolchain base URL from TC_VERSION_MAP metadata
#  - constructs the final download URL and archive name
#  - provides lookup macros used by toolchain rules
#
###############################################################################

ifeq ($(strip $(TC_WWW)),)
TC_WWW = $(call toolchain-url,$(TC_VERS))
endif

ifeq ($(strip $(TC_DIST_SITE_URL)),)
TC_DIST_SITE_URL = \
  $(if $(filter na,$(TC_WWW)),,\
    https://$(TC_WWW)/$(call toolchain-download-url,$(TC_WWW)))
endif

# TC_DIST_SITE_PATH is defined in toolchain specific Makefile
ifeq ($(strip $(TC_DIST_SITE)),)
TC_DIST_SITE = $(TC_DIST_SITE_URL)/$(TC_DIST_SITE_PATH)
endif

ifeq ($(strip $(TC_EXT)),)
TC_EXT = txz
endif

# TC_DIST is defined in toolchain specific Makefile
ifeq ($(strip $(TC_DIST_NAME)),)
TC_DIST_NAME = $(TC_DIST).$(TC_EXT)
endif

####
# Macro definitions

toolchain-map = \
  $(strip $(foreach m,$(TC_VERSION_MAP),\
    $(if $(filter $(1):%,$(m)),$(m))))

toolchain-build = \
  $(word 2,$(subst :, ,$(call toolchain-map,$(1))))

toolchain-type = \
  $(word 3,$(subst :, ,$(call toolchain-map,$(1))))

toolchain-url = \
  $(word 4,$(subst :, ,$(call toolchain-map,$(1))))

toolchain-download-url = \
  $(strip $(foreach u,$(TC_URL_MAP),\
    $(if $(filter $(1):%,$(u)),\
      $(patsubst $(1):%,%,$(u)))))

TC_URL_MAP = \
    global.synologydownload.com:download/ToolChain/toolchain/$(TC_VERS)-$(TC_BUILD) \
    github.com/SynoCommunity/spksrc:releases/download \
    sourceforge.net:projects/dsgpl/files/Tool%20Chain/$(TC_TYPE)%20$(TC_VERS)%20Tool%20Chains
