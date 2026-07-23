PKG_NAME = cairo-virtual

OPTIONAL_DEPENDS  = cross/cairo-latest
OPTIONAL_DEPENDS += cross/cairo-1.16

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS) $(ARMv5_ARCHS)),$(ARCH))
DEPENDS = cross/cairo-1.16
else
DEPENDS = cross/cairo-latest
endif

include ../../mk/spksrc.cross-virtual.mk
