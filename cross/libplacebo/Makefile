PKG_NAME = libplacebo
PKG_VERS = 7.360.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/haasn/libplacebo/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://libplacebo.org
COMMENT  = libplacebo is, in a nutshell, the core rendering algorithms and ideas of mpv rewritten as an independent library.
LICENSE  = LGPL-2.1 license

DEPENDS += cross/mesa
DEPENDS += cross/Khronos-Vulkan-Loader
DEPENDS += cross/Khronos-Vulkan-Tools
DEPENDS += cross/shaderc

CONFIGURE_ARGS += -Dopengl=disabled

# vk.xml is installed by cross/Khronos-Vulkan-Headers. When libplacebo is built
# as part of a videodriver meta consumer (e.g. ffmpeg on DSM 7.2, where GCC>=12
# enables libplacebo), Vulkan-Headers is shared through the meta build cookies
# and only installed into the videodriver staging, not libplacebo's own — so
# look there as well. The local staging takes precedence for standalone builds.
# (evaluated when CONFIGURE_ARGS is expanded at configure time, i.e. after depend)
VULKAN_REGISTRY = $(firstword $(wildcard \
	$(STAGING_INSTALL_PREFIX)/share/vulkan/registry/vk.xml \
	$(VIDEODRV_STAGING_INSTALL_PREFIX)/share/vulkan/registry/vk.xml))
CONFIGURE_ARGS += -Dvulkan-registry=$(VULKAN_REGISTRY)

include ../../mk/spksrc.cross-meson.mk
