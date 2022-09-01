PKG_NAME = libva
PKG_VERS = 2.15.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/libva/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libdrm

HOMEPAGE = https://01.org/vaapi
COMMENT  = Libva is an implementation for VA-API (Video Acceleration API).
LICENSE = MIT

CONFIGURE_ARGS = -Ddriverdir=$(INSTALL_PREFIX)/lib

include ../../mk/spksrc.common.mk

# freedreno: All except i686/x86_64
# intel: i686/x86_64
# amdgpu+radeon: x86_64
ifeq ($(findstring $(ARCH),$(i686_ARCHS) $(x64_ARCHS)),$(ARCH))
PLIST_TRANSFORM = grep -v -e libdrm_freedreno.so
else
PLIST_TRANSFORM = grep -v -e libdrm_amdgpu.so -e libdrm_intel.so -e libdrm_radeon.so
endif
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
PLIST_TRANSFORM += -e libdrm_amdgpu.so -e libdrm_radeon.so
endif

include ../../mk/spksrc.cross-meson.mk
