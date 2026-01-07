PKG_NAME = libaom-main

OPTIONAL_DEPENDS  = cross/libaom-latest
OPTIONAL_DEPENDS += cross/libaom-3.8

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

include ../../mk/spksrc.main-depends.mk

# gcc >= 7.5
ifeq ($(call version_ge, $(TC_GCC), 7.5),1)
DEPENDS = cross/libaom-latest
else
DEPENDS = cross/libaom-3.8
endif
