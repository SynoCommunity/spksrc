PKG_NAME = intel-gmmlib-virtual

OPTIONAL_DEPENDS  = cross/intel-gmmlib-latest
OPTIONAL_DEPENDS += cross/intel-gmmlib-22.3

include ../../mk/spksrc.common.mk

# The current Intel generation wherever media-driver-latest builds (MIN_GCC_VERSION 5):
# libva, gmmlib and mediasdk follow it, keeping the 22.x set for the older compilers.
ifeq ($(call version_ge, $(TC_GCC), 5),1)
DEPENDS = cross/intel-gmmlib-latest
else
DEPENDS = cross/intel-gmmlib-22.3
endif

include ../../mk/spksrc.cross-virtual.mk
