PKG_NAME = libsigc++-main

# support for c++11 language features is required for libsigc++-2.12
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

OPTIONAL_DEPENDS  = cross/libsigc++-latest
OPTIONAL_DEPENDS += cross/libsigc++-2.12

include ../../mk/spksrc.main-depends.mk

ifeq ($(call version_ge, $(TC_GCC), 7.5),1)
DEPENDS = cross/libsigc++-latest
else
DEPENDS = cross/libsigc++-2.12
endif
