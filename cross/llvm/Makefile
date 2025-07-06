PKG_NAME = llvm-main

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

OPTIONAL_DEPENDS  = cross/llvm-latest
OPTIONAL_DEPENDS += cross/llvm-9.0

include ../../mk/spksrc.main-depends.mk

ifeq ($(call version_ge, $(TC_GCC), 5.1),1)
DEPENDS = cross/llvm-latest
else
DEPENDS = cross/llvm-9.0
endif
