PKG_NAME = binutils-main

OPTIONAL_DEPENDS  = cross/binutils-latest
OPTIONAL_DEPENDS += cross/binutils-2.41
OPTIONAL_DEPENDS += cross/binutils-2.32

include ../../mk/spksrc.main-depends.mk

ifeq ($(call version_lt, $(TC_GCC), 4.4),1)
DEPENDS = cross/binutils-2.32
else ifeq ($(call version_lt, $(TC_GCC), 4.8.1),1)
DEPENDS = cross/binutils-2.41
else
DEPENDS = cross/binutils-latest
endif
