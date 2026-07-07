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
CONFIGURE_ARGS += -Dvulkan-registry=$(STAGING_INSTALL_PREFIX)/share/vulkan/registry/vk.xml

include ../../mk/spksrc.cross-meson.mk
