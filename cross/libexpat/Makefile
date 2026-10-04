PKG_NAME = libexpat-virtual

OPTIONAL_DEPENDS  = cross/libexpat-latest
OPTIONAL_DEPENDS += cross/libexpat-2.8.4

include ../../mk/spksrc.common.mk

# 2.8.5 needs gcc >= 4.5 (__deprecated__ with message in expat.h);
# older toolchains stay on the frozen 2.8.4 line
ifeq ($(call version_ge, $(TC_GCC), 4.5),1)
DEPENDS = cross/libexpat-latest
else
DEPENDS = cross/libexpat-2.8.4
endif

include ../../mk/spksrc.cross-virtual.mk
