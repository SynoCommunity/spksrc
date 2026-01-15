PKG_NAME = libicu-main

OPTIONAL_DEPENDS  = cross/libicu-latest
OPTIONAL_DEPENDS += cross/libicu-74.2

include ../../mk/spksrc.main-depends.mk

# If gcc >= 5 (i.e. DSM >= 7.0)
ifeq ($(call version_ge, $(TC_GCC), 5),1)
DEPENDS = cross/libicu-latest
else
DEPENDS = cross/libicu-74.2
endif
