PKG_NAME = glibc-main

OPTIONAL_DEPENDS  = cross/glibc-latest
OPTIONAL_DEPENDS += cross/glibc-2.28

include ../../mk/spksrc.main-depends.mk

ifeq ($(call version_ge, $(TC_GCC), 5.1),1)
DEPENDS = cross/glibc-latest
else
DEPENDS = cross/glibc-2.28
endif
