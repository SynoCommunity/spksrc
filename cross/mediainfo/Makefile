PKG_NAME = mediainfo-main

OPTIONAL_DEPENDS  = cross/mediainfo-latest
OPTIONAL_DEPENDS += cross/mediainfo-25.04

include ../../mk/spksrc.main-depends.mk

ifeq ($(call version_ge, ${TC_GCC}, 5),1)
DEPENDS = cross/mediainfo-latest
else
DEPENDS = cross/mediainfo-25.04
endif
