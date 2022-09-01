PKG_NAME = libdrm
PKG_VERS = 2.4.113
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://dri.freedesktop.org/libdrm
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpciaccess

HOMEPAGE =
COMMENT = Userspace interface to kernel DRM services
LICENSE =

CONFIGURE_ARGS = -Dlibdir=lib
CONFIGURE_ARGS += -Dnouveau=disabled
CONFIGURE_ARGS += -Dvmwgfx=disabled

include ../../mk/spksrc.archs.mk

# If not generic or specific to AMD v1000
# then disable radeon driver
ifneq ($(findstring $(ARCH),x64 v1000),$(ARCH))
CONFIGURE_ARGS += -Dradeon=disabled
CONFIGURE_ARGS += -Damdgpu=disabled
endif

include ../../mk/spksrc.cross-meson.mk
