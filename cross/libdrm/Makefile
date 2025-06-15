PKG_NAME = libdrm
PKG_VERS = 2.4.123
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://dri.freedesktop.org/libdrm
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpciaccess

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

HOMEPAGE = https://dri.freedesktop.org/wiki/DRM/
COMMENT = Userspace interface to kernel DRM services.
LICENSE = https://developer.puri.sm/licenses/Librem5/Birch/libdrm-common/copyright

CONFIGURE_ARGS  = -Dlibdir=lib
CONFIGURE_ARGS += -Dnouveau=disabled
CONFIGURE_ARGS += -Dvmwgfx=disabled

# drivers supported on dedicated CPUs only
# - amdgpu	(all 64bit intel CPU)
# - etnaviv	(all ARM CPU)
# - freedreno 	(all ARM CPU)
# - intel	(all intel CPU)
# - radeon	(all 64bit intel CPU)
include ../../mk/spksrc.archs.mk
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

ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-meson.mk
