PKG_NAME = gdb-virtual

OPTIONAL_DEPENDS  = cross/gdb-latest
OPTIONAL_DEPENDS += cross/gdb-7.12
OPTIONAL_DEPENDS += cross/gdb-14.2

include ../../mk/spksrc.common.mk

ifeq ($(call version_lt, $(TC_GCC), 4.8.1),1)
DEPENDS += cross/gdb-7.12
else ifeq ($(call version_lt, $(TC_GCC), 5),1)
DEPENDS += cross/gdb-14.2
else
DEPENDS += cross/gdb-latest
endif

include ../../mk/spksrc.cross-virtual.mk
