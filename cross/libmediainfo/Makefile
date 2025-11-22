PKG_NAME = libmediainfo-main

OPTIONAL_DEPENDS  = cross/libmediainfo-latest
OPTIONAL_DEPENDS += cross/libmediainfo-25.04

include ../../mk/spksrc.main-depends.mk

ifeq ($(call version_ge, ${TC_GCC}, 5),1)
DEPENDS = cross/libmediainfo-latest
else
DEPENDS = cross/libmediainfo-25.04
endif
