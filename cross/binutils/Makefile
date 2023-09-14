PKG_NAME = binutils-main

OPTIONAL_DEPENDS  = cross/binutils-latest
OPTIONAL_DEPENDS += cross/binutils-2.32

include ../../mk/spksrc.main-depends.mk

ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS = cross/binutils-2.32
else
DEPENDS = cross/binutils-latest
endif
