PKG_NAME = intel-media-main

OPTIONAL_DEPENDS  = cross/intel-media-driver-latest
OPTIONAL_DEPENDS += cross/intel-media-driver-22.5

include ../../mk/spksrc.main-depends.mk

ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
DEPENDS = cross/intel-media-driver-latest
else
DEPENDS = cross/intel-media-driver-22.5
endif
