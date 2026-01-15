PKG_NAME = nnn-main

OPTIONAL_DEPENDS  = cross/nnn-latest
OPTIONAL_DEPENDS += cross/nnn-4.8
OPTIONAL_DEPENDS += cross/nnn-4.0

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

include ../../mk/spksrc.main-depends.mk

ifeq ($(call version_ge, $(TC_GCC), 5.0),1)
DEPENDS += cross/nnn-latest
else ifeq ($(findstring $(ARCH),$(64bit_ARCHS)),$(ARCH))
DEPENDS += cross/nnn-4.8
else
# 32-bit archs for DSM<7
DEPENDS += cross/nnn-4.0
endif
