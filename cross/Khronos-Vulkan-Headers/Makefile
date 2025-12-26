PKG_NAME = Vulkan-Headers
PKG_VERS = 1.4.337
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = khronos-$(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/KhronosGroup/Vulkan-Headers/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/KhronosGroup/Vulkan-Headers
COMMENT = Vulkan header files and API registry
LICENSE = Apache-2.0

DEPENDS = 

#CMAKE_ARGS  = -DBUILD_WSI_XCB_SUPPORT='OFF'
#CMAKE_ARGS += -DBUILD_WSI_XLIB_SUPPORT='OFF'
#CMAKE_ARGS += -DBUILD_WSI_WAYLAND_SUPPORT='OFF'
#CMAKE_ARGS  = -DENABLE_OPT='OFF'
#CMAKE_ARGS += -DALLOW_EXTERNAL_SPIRV_TOOLS='ON'
#CMAKE_ARGS += -DBUILD_SHARED_LIBS='ON'
#CMAKE_ARGS += -DGLSLANG_TESTS='ON'
#CMAKE_ARGS += -DCMAKE_CXX_STANDARD_LIBRARIES="-lstdc++fs"

include ../../mk/spksrc.cross-cmake.mk
