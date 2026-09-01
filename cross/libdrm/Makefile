PKG_NAME = libdrm
PKG_VERS = 2.4.131
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://dri.freedesktop.org/libdrm
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpciaccess

# No compiler floor: the old ARMv5 / old-PowerPC exclusion was not about the compiler
# at all, it was meson's c_std=c11 (see the override below). With that fixed, 4.3.7
# builds this.

HOMEPAGE = https://dri.freedesktop.org/wiki/DRM/
COMMENT = Userspace interface to kernel DRM services.
LICENSE = https://developer.puri.sm/licenses/Librem5/Birch/libdrm-common/copyright

CONFIGURE_ARGS  = -Dlibdir=lib
CONFIGURE_ARGS += -Dnouveau=disabled
CONFIGURE_ARGS += -Dvmwgfx=disabled

ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.common.mk

# libdrm's meson.build asks for c_std=c11; gcc < 4.7 only knows -std=c1x and dies on
# "unrecognized command line option '-std=c11'". Override meson's option rather than
# fighting it from CFLAGS.
ifeq ($(call version_lt,$(TC_GCC),4.7),1)
CONFIGURE_ARGS += -Dc_std=gnu99
endif

# drivers supported on dedicated CPUs only
# - amdgpu	(all 64bit intel CPU)
# - etnaviv	(all ARM CPU)
# - freedreno 	(all ARM CPU)
# - intel	(all intel CPU)
# - radeon	(all 64bit intel CPU)
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
PLIST_TRANSFORM = grep -v -e libdrm_intel -e libdrm_amdgpu -e libdrm_radeon -e libdrm_etnaviv -e libdrm_freedreno
endif
ifeq ($(findstring $(ARCH),$(ARM_ARCHS)),$(ARCH))
PLIST_TRANSFORM = grep -v -e libdrm_intel -e libdrm_amdgpu -e libdrm_radeon
endif
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
PLIST_TRANSFORM = grep -v -e libdrm_etnaviv -e libdrm_freedreno
endif
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
PLIST_TRANSFORM = grep -v -e libdrm_amdgpu -e libdrm_radeon -e libdrm_etnaviv -e libdrm_freedreno
endif

include ../../mk/spksrc.cross-meson.mk
