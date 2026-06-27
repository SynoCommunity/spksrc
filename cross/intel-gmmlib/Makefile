PKG_NAME = intel-gmmlib-main

OPTIONAL_DEPENDS  = cross/intel-gmmlib-latest
OPTIONAL_DEPENDS += cross/intel-gmmlib-22.3

include ../../mk/spksrc.common.mk

ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
DEPENDS = cross/intel-gmmlib-latest
else
DEPENDS = cross/intel-gmmlib-22.3
endif

include ../../mk/spksrc.main-depends.mk
