PKG_NAME = gdb-main

OPTIONAL_DEPENDS  = cross/gdb-latest
OPTIONAL_DEPENDS += cross/gdb-7.12

include ../../mk/spksrc.main-depends.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
DEPENDS += cross/gdb-7.12
else
ifeq ($(call version_lt, $(TC_GCC), 4.8),1)
DEPENDS += cross/gdb-7.12
else
# A compiler with support for C++11 language features is required.
DEPENDS += cross/gdb-latest
endif
endif
