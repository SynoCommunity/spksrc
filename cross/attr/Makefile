PKG_NAME = attr-virtual

OPTIONAL_DEPENDS  = cross/attr-latest
OPTIONAL_DEPENDS += cross/attr-2.5

include ../../mk/spksrc.common.mk

ifeq ($(call version_le, $(TC_GCC), 4.4),1)
# AT_EMPTY_PATH (<fcntl.h>) and #pragma GCC not available
DEPENDS = cross/attr-2.5
else
DEPENDS = cross/attr-latest
endif

include ../../mk/spksrc.cross-virtual.mk
