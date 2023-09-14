PKG_NAME = gdb-main

OPTIONAL_DEPENDS  = cross/gdb-latest
OPTIONAL_DEPENDS += cross/gdb-7.12

include ../../mk/spksrc.main-depends.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
DEPENDS += cross/gdb-7.12
else
DEPENDS += cross/gdb-latest
endif
