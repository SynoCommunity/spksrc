PKG_NAME = cairo-main

OPTIONAL_DEPENDS  = cross/cairo-latest
OPTIONAL_DEPENDS += cross/cairo-1.16

include ../../mk/spksrc.main-depends.mk

ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS) $(ARMv5-ARCHS)),$(ARCH))
DEPENDS = cross/cairo-1.16
else
DEPENDS = cross/cairo-latest
endif
