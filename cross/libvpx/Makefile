PKG_NAME = libvpx-virtual

OPTIONAL_DEPENDS  = cross/libvpx-latest
OPTIONAL_DEPENDS += cross/libvpx-1.14

MIN_GCC_VERSION = 4.6

include ../../mk/spksrc.common.mk

# libvpx-latest (1.16) dropped the ARMv5 and PowerPC targets upstream -- it offers
# only armv7/armv8/x86 -- so route those to 1.14, which still has a --target=generic-gnu
# case for them, regardless of how new the compiler is. Compiler version and ISA
# support are separate questions, and a gcc overlay makes the difference visible: an
# ARMv5/PPC arch can now have gcc 8.5, and the bare gcc gate below would then send it
# to a libvpx that has no target for it. Everything else: latest on gcc >= 7.5
# (DSM >= 7.0), 1.14 below.
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
DEPENDS = cross/libvpx-1.14
else ifeq ($(call version_ge, $(TC_GCC), 7.5),1)
DEPENDS = cross/libvpx-latest
else
DEPENDS = cross/libvpx-1.14
endif

include ../../mk/spksrc.cross-virtual.mk
