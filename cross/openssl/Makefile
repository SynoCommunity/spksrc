PKG_NAME = openssl-main

OPTIONAL_DEPENDS  = cross/openssl-latest
OPTIONAL_DEPENDS += cross/openssl-3.1
OPTIONAL_DEPENDS += cross/openssl-1.1

include ../../mk/spksrc.main-depends.mk

# threads need libatomic that is missing in ARMv5 & old PPC toolchain
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS = cross/openssl-1.1
else
DEPENDS = cross/openssl-3.1
endif
