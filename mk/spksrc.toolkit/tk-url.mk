###############################################################################
# spksrc.toolkit/tk-url.mk
#
# Resolves toolkit download locations and filenames.
#
# This file:
#  - derives the toolkit base URL from TK_VERSION_MAP metadata
#  - constructs the final download URL and archive name
#  - provides lookup macros used by toolkit rules
#
###############################################################################

ifeq ($(strip $(TK_WWW)),)
TK_WWW = $(call toolkit-url,$(TK_VERS))
endif

ifeq ($(strip $(TK_DIST_SITE_URL)),)
TK_DIST_SITE_URL = \
  $(if $(filter na,$(TK_WWW)),,\
    https://$(TK_WWW)/$(call toolkit-download-url,$(TK_WWW)))
endif

ifeq ($(strip $(TK_DIST_SITE)),)
TK_DIST_SITE = $(TK_DIST_SITE_URL)/$(or $(TK_DIST_VERS),$(TK_VERS))/$(or $(TK_DIST),$(TK_ARCH))
endif

ifeq ($(strip $(TK_DIST_PREFIX)),)
TK_DIST_PREFIX = ds.
endif

ifeq ($(strip $(TK_DIST_SUFFIX)),)
TK_DIST_SUFFIX = .dev
endif

ifeq ($(strip $(TK_EXT)),)
TK_EXT = txz
endif

ifeq ($(strip $(TK_DIST)),)
TK_DIST = $(TK_ARCH)
endif

ifeq ($(strip $(TK_DIST_NAME)),)
TK_DIST_NAME = $(TK_DIST_PREFIX)$(TK_DIST)-$(or $(TK_DIST_VERS),$(TK_VERS))$(TK_DIST_SUFFIX).$(TK_EXT)
endif

####
# Macro definitions

toolkit-map = \
  $(strip $(foreach m,$(TK_VERSION_MAP),\
    $(if $(filter $(1):%,$(m)),$(m))))

toolkit-build = \
  $(word 2,$(subst :, ,$(call toolkit-map,$(1))))

toolkit-type = \
  $(word 3,$(subst :, ,$(call toolkit-map,$(1))))

toolkit-url = \
  $(word 4,$(subst :, ,$(call toolkit-map,$(1))))

toolkit-download-url = \
  $(strip $(foreach u,$(TK_URL_MAP),\
    $(if $(filter $(1):%,$(u)),\
      $(patsubst $(1):%,%,$(u)))))

TK_URL_MAP = global.synologydownload.com:download/ToolChain/toolkit
