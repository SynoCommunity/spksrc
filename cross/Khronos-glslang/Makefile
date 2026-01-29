PKG_NAME = glslang
PKG_VERS = 16.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = khronos-$(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/KhronosGroup/glslang/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/KhronosGroup/glslang
COMMENT = An OpenGL GLSL and OpenGL|ES GLSL (ESSL) front-end for reference validation and translation of GLSL/ESSL into an internal abstract syntax tree (AST).
LICENSE = Copyright (c) 2015-2024 The Khronos Group Inc.

DEPENDS = cross/Khronos-SPIRV-Tools

CMAKE_ARGS  = -DENABLE_OPT='OFF'
CMAKE_ARGS += -DALLOW_EXTERNAL_SPIRV_TOOLS='ON'
CMAKE_ARGS += -DBUILD_SHARED_LIBS='ON'
CMAKE_ARGS += -DGLSLANG_TESTS='ON'
CMAKE_ARGS += -DCMAKE_CXX_STANDARD_LIBRARIES="-lstdc++fs"

include ../../mk/spksrc.cross-cmake.mk
