PKG_NAME = libdrm
PKG_VERS = 2.4.103
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://dri.freedesktop.org/libdrm
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpciaccess

HOMEPAGE =
COMMENT = Userspace interface to kernel DRM services
LICENSE =

CONFIGURE_ARGS = -Dlibdir=lib
CONFIGURE_ARGS += -Dradeon=false
CONFIGURE_ARGS += -Damdgpu=false
CONFIGURE_ARGS += -Dnouveau=false
CONFIGURE_ARGS += -Dvmwgfx=false

include ../../mk/spksrc.cross-meson.mk
