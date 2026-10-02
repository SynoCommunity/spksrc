PKG_NAME = intel-mediasdk-virtual

OPTIONAL_DEPENDS  = cross/intel-mediasdk-latest
OPTIONAL_DEPENDS += cross/intel-mediasdk-22.5

# The Intel media stack drives i915 ioctls the running kernel either has or has not;
# DSM 5.2's 3.2 kernel predates the render-node interface libva needs.
MIN_KERNEL_VERSION = 3.10

include ../../mk/spksrc.common.mk

# The current Intel generation wherever media-driver-latest builds (MIN_GCC_VERSION 5):
# gmmlib and mediasdk follow it, keeping the 22.x set for the older compilers. libva is
# one version for both: newer libva loads drivers built for an older VA-API.
ifeq ($(call version_ge, $(TC_GCC), 5),1)
DEPENDS = cross/intel-mediasdk-latest
else
DEPENDS = cross/intel-mediasdk-22.5
endif

include ../../mk/spksrc.cross-virtual.mk
