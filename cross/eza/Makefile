PKG_NAME = eza-main

OPTIONAL_DEPENDS  = cross/eza-latest
OPTIONAL_DEPENDS += cross/eza-0.20.18

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

include ../../mk/spksrc.main-depends.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
DEPENDS = cross/eza-0.20.18
else
DEPENDS = cross/eza-latest
endif
