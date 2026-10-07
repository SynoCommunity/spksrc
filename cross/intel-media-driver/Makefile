PKG_NAME = intel-media-virtual

# The current Intel generation wherever media-driver-latest builds (MIN_GCC_VERSION 5):
# gmmlib and mediasdk follow it, keeping the 22.x set for the older compilers. libva is
# one version for both: newer libva loads drivers built for an older VA-API.

include ../../mk/spksrc.common.mk

$(call depend,cross/intel-media-driver-latest|cross/intel-media-driver-22.5)

include ../../mk/spksrc.cross-virtual.mk
