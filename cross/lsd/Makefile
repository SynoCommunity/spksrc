PKG_NAME = lsd-main

OPTIONAL_DEPENDS  = cross/lsd-latest
OPTIONAL_DEPENDS += cross/lsd-1.1

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

include ../../mk/spksrc.main-depends.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
DEPENDS = cross/lsd-1.1
else
DEPENDS = cross/lsd-latest
endif
