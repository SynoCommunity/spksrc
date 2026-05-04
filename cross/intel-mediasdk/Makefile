PKG_NAME = intel-mediasdk-main

OPTIONAL_DEPENDS  = cross/intel-mediasdk-latest
OPTIONAL_DEPENDS += cross/intel-mediasdk-22.5

include ../../mk/spksrc.common.mk

ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
DEPENDS = cross/intel-mediasdk-latest
else
DEPENDS = cross/intel-mediasdk-22.5
endif

include ../../mk/spksrc.main-depends.mk
