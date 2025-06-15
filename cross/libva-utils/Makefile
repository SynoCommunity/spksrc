PKG_NAME = libva-utils-main

OPTIONAL_DEPENDS  = cross/libva-utils-latest
OPTIONAL_DEPENDS += cross/libva-utils-2.17

include ../../mk/spksrc.main-depends.mk

ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
DEPENDS = cross/libva-utils-latest
else
DEPENDS = cross/libva-utils-2.17
endif
