PKG_NAME = pngquant-main

OPTIONAL_DEPENDS  = cross/pngquant3
OPTIONAL_DEPENDS += cross/pngquant2

include ../../mk/spksrc.main-depends.mk

ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS) $(ARMv5_ARCHS)),$(ARCH))
# std=c11 not fully supported
DEPENDS = cross/pngquant2
else
DEPENDS = cross/pngquant3
endif
