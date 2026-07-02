PKG_NAME = fuse3-main

OPTIONAL_DEPENDS  = cross/fuse3-latest
OPTIONAL_DEPENDS += cross/fuse3.16

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
DEPENDS = cross/fuse3.16
else
DEPENDS = cross/fuse3-latest
endif

include ../../mk/spksrc.main-depends.mk
