PKG_NAME = mediainfo-virtual

OPTIONAL_DEPENDS  = cross/mediainfo-latest
OPTIONAL_DEPENDS += cross/mediainfo-25.04

# 25.04 fallback needs -std=c++11
MIN_GCC_VERSION = 4.7

include ../../mk/spksrc.common.mk

# GCC >= 5 (DSM >= 7.0)
ifeq ($(call version_ge, $(TC_GCC), 5),1)
DEPENDS = cross/mediainfo-latest
else
DEPENDS = cross/mediainfo-25.04
endif

include ../../mk/spksrc.cross-virtual.mk
