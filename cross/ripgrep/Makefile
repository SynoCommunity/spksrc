PKG_NAME = ripgrep-main

OPTIONAL_DEPENDS  = cross/ripgrep-latest
OPTIONAL_DEPENDS += cross/ripgrep-14

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

include ../../mk/spksrc.main-depends.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
DEPENDS += cross/ripgrep-14
else ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
ifeq ($(call version_le, $(TC_GCC), 5.0),1)
DEPENDS += cross/ripgrep-14
else
DEPENDS += cross/ripgrep-latest
endif
else
DEPENDS += cross/ripgrep-latest
endif
