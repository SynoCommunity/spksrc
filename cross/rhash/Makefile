PKG_NAME = rhash-main

OPTIONAL_DEPENDS  = cross/rhash-latest
OPTIONAL_DEPENDS += cross/rhash-1.4.5

include ../../mk/spksrc.main-depends.mk

ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS = cross/rhash-1.4.5
else
DEPENDS = cross/rhash-latest
endif
