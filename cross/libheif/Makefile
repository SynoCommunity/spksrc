PKG_NAME = libheif-main

OPTIONAL_DEPENDS  = cross/libheif-latest
OPTIONAL_DEPENDS += cross/libheif-1.18

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

include ../../mk/spksrc.main-depends.mk

# support for C++20
ifeq ($(call version_ge, $(TC_GCC), 8.5),1)
DEPENDS = cross/libheif-latest
else
DEPENDS = cross/libheif-1.18
endif
