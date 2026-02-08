PKG_NAME = z3-main

OPTIONAL_DEPENDS += cross/z3-4.11
OPTIONAL_DEPENDS += cross/z3-4.7

include ../../mk/spksrc.main-depends.mk

ifeq ($(call version_ge, $(TC_GCC), 5),1)
DEPENDS = cross/z3-4.11
else
DEPENDS = cross/z3-4.7
endif
