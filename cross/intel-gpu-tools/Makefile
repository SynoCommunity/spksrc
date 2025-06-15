PKG_NAME = igt-gpu-tools
PKG_VERS = 1.29
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gitlab.freedesktop.org/drm/igt-gpu-tools/-/archive/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-v$(PKG_VERS)

DEPENDS  = cross/libdrm cross/libkmod cross/procps-ng cross/elfutils
DEPENDS += cross/pixman cross/cairo
DEPENDS += cross/libudev_219

HOMEPAGE = https://gitlab.freedesktop.org/drm/igt-gpu-tools
COMMENT  = IGT GPU Tools is a collection of tools for development and testing of the DRM drivers.
LICENSE  = MIT License

## NOTE:
## intel_gpu_top and most of the tools requires a kernel >= 4.16/4.17
## as such only a subset is being packaged part of synocli-videodriver

UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS)

CONFIGURE_ARGS  = -Ddocs=disabled
CONFIGURE_ARGS += -Dman=disabled
CONFIGURE_ARGS += -Dtestplan=disabled
CONFIGURE_ARGS += -Dtests=disabled

include ../../mk/spksrc.cross-meson.mk
