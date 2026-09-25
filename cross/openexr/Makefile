PKG_NAME = openexr-virtual

OPTIONAL_DEPENDS  = cross/openexr-latest
OPTIONAL_DEPENDS += cross/openexr-2.5

include ../../mk/spksrc.common.mk

# 3.x needs std::filesystem without -lstdc++fs (GCC 9+); older
# toolchains stay on the frozen 2.5 line
ifeq ($(call version_ge, $(TC_GCC), 9),1)
DEPENDS = cross/openexr-latest
else
DEPENDS = cross/openexr-2.5
endif

include ../../mk/spksrc.cross-virtual.mk
