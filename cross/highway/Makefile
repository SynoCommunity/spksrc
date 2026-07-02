PKG_NAME = highway
PKG_VERS = 1.3.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/google/highway/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# Minimum GCC version required is 7
REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k

HOMEPAGE = https://google.github.io/highway/
COMMENT  = Performance-portable, length-agnostic SIMD with runtime dispatch.
LICENSE  = Apache 2.0 / 3-Clause BSD

CMAKE_ARGS += -DBUILD_SHARED_LIBS=ON
CMAKE_ARGS += -DHWY_ENABLE_TESTS=OFF
CMAKE_ARGS += -DHWY_ENABLE_EXAMPLES=OFF

include ../../mk/spksrc.cross-cmake.mk
