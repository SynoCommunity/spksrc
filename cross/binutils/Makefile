PKG_NAME = binutils-main

OPTIONAL_DEPENDS  = cross/binutils-latest
OPTIONAL_DEPENDS += cross/binutils-2.32

include ../../mk/spksrc.main-depends.mk

ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS = cross/binutils-2.32
else ifeq ($(call version_lt, $(TCVERSION), 7),1) 
DEPENDS = cross/binutils-2.41
else ifeq ($(findstring $(ARCH),comcerto2k),$(ARCH))
DEPENDS = cross/binutils-2.41
else
DEPENDS = cross/binutils-latest
endif
