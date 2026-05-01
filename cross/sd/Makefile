PKG_NAME = sd-main

OPTIONAL_DEPENDS  = cross/sd-latest
OPTIONAL_DEPENDS += cross/sd-1.0

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

include ../../mk/spksrc.main-depends.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
# latest version that builds with rustc 1.72.2 and 1.82.0 (version 1.1.x requires rustc edition 2024, i.e. rustc 1.86.0)
DEPENDS = cross/sd-1.0
else
DEPENDS = cross/sd-latest
endif
