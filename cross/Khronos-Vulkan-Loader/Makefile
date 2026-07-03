PKG_NAME = Vulkan-Loader
PKG_VERS = 1.4.337
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = khronos-$(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/KhronosGroup/Vulkan-Loader
COMMENT = Khronos official Vulkan Loader for all platforms except Android
LICENSE = Apache License Version 2.0

DEPENDS = cross/Khronos-Vulkan-Headers

CMAKE_ARGS  = -DBUILD_WSI_XCB_SUPPORT='OFF'
CMAKE_ARGS += -DBUILD_WSI_XLIB_SUPPORT='OFF'
CMAKE_ARGS += -DBUILD_WSI_WAYLAND_SUPPORT='OFF'

include ../../mk/spksrc.cross-cmake.mk
