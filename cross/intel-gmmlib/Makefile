PKG_NAME = intel-gmmlib-virtual

# The current Intel generation wherever media-driver-latest builds (MIN_GCC_VERSION 5):
# gmmlib and mediasdk follow it, keeping the 22.x set for the older compilers. libva is
# one version for both: newer libva loads drivers built for an older VA-API.

$(call depend,cross/intel-gmmlib-latest|cross/intel-gmmlib-22.3,nop)

include ../../mk/spksrc.cross-virtual.mk
