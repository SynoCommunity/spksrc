PKG_NAME = Vulkan-Tools
PKG_VERS = 1.4.337
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = khronos-$(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/KhronosGroup/Vulkan-Tools/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/KhronosGroup/Vulkan-Tools
COMMENT = Vulkan tools and utilities that can assist development by enabling developers to verify their applications correct use of the Vulkan API.
LICENSE = Apache-2.0

DEPENDS  = cross/Khronos-Vulkan-Headers

CMAKE_ARGS  = -DBUILD_CUBE='OFF'
CMAKE_ARGS += -DBUILD_WSI_XCB_SUPPORT='OFF'
CMAKE_ARGS += -DBUILD_WSI_XLIB_SUPPORT='OFF'
CMAKE_ARGS += -DBUILD_WSI_WAYLAND_SUPPORT='OFF'

include ../../mk/spksrc.cross-cmake.mk
