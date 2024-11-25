PKG_NAME = libva-main

OPTIONAL_DEPENDS  = cross/libva-latest
OPTIONAL_DEPENDS += cross/libva-2.17

include ../../mk/spksrc.main-depends.mk

ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
DEPENDS = cross/libva-latest
else
DEPENDS = cross/libva-2.17
endif
