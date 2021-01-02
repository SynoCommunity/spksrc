PKG_NAME = libdrm
PKG_VERS = 2.4.100
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://dri.freedesktop.org/libdrm
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpciaccess

HOMEPAGE =
COMMENT = Userspace interface to kernel DRM services
LICENSE =

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --disable-radeon
CONFIGURE_ARGS += --disable-amdgpu
CONFIGURE_ARGS += --disable-nouveau

include ../../mk/spksrc.cross-cc.mk
