PKG_NAME = c-ares-main

OPTIONAL_DEPENDS  = cross/c-ares-latest
OPTIONAL_DEPENDS += cross/c-ares-1.28

include ../../mk/spksrc.main-depends.mk

ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS = cross/c-ares-1.28
else
DEPENDS = cross/c-ares-latest
endif
