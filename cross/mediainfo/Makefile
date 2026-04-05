PKG_NAME = mediainfo-main

OPTIONAL_DEPENDS  = cross/mediainfo-latest
OPTIONAL_DEPENDS += cross/mediainfo-25.04

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

include ../../mk/spksrc.main-depends.mk

# GCC >= 5 (DSM >= 7.0)
ifeq ($(call version_ge, $(TC_GCC), 5),1)
DEPENDS = cross/mediainfo-latest
else
DEPENDS = cross/mediainfo-25.04
endif
