PKG_NAME = bat-main

OPTIONAL_DEPENDS  = cross/bat-latest
OPTIONAL_DEPENDS += cross/bat-0.25

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

include ../../mk/spksrc.main-depends.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
DEPENDS = cross/bat-0.25
else
DEPENDS = cross/bat-latest
endif
