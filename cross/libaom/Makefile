PKG_NAME = libaom-virtual

OPTIONAL_DEPENDS  = cross/libaom-latest
OPTIONAL_DEPENDS += cross/libaom-3.8

MIN_GCC_VERSION = 4.8
# Neither libaom version has an ARMv5 or old-PowerPC target, whatever the compiler.
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

include ../../mk/spksrc.common.mk

# libaom-latest needs gcc >= 7.5 AND DSM >= 7.0 (REQUIRED_MIN_DSM), and excludes
# comcerto2k. The virtual's pick has to match what the child actually supports or it
# fails downstream: a gcc overlay gives a DSM 6.2.4 arch gcc 8.5, and a bare gcc gate
# would then route it to libaom-latest, which refuses it on REQUIRED_MIN_DSM. Route
# anything libaom-latest cannot serve to libaom-3.8; same shape as the libvpx selector.
ifeq ($(findstring $(ARCH),comcerto2k),$(ARCH))
DEPENDS = cross/libaom-3.8
else ifeq ($(call version_lt, $(TCVERSION), 7.0),1)
DEPENDS = cross/libaom-3.8
else ifeq ($(call version_ge, $(TC_GCC), 7.5),1)
DEPENDS = cross/libaom-latest
else
DEPENDS = cross/libaom-3.8
endif

include ../../mk/spksrc.cross-virtual.mk
