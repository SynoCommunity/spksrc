PKG_NAME = jsoncpp
PKG_VERS = 1.9.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/open-source-parsers/jsoncpp/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/open-source-parsers/jsoncpp/wiki
COMMENT  = A C++ library for interacting with JSON.
LICENSE  = MIT

GNU_CONFIGURE = 1

CMAKE_ARGS += -DJSONCPP_WITH_TESTS=no
CMAKE_ARGS += -DJSONCPP_WITH_POST_BUILD_UNITTEST=no

include ../../mk/spksrc.cross-cmake.mk

# Fix compilation with newer compilers
# Flags to be added to CMake toolchain file
ifeq ($(call version_ge, ${TC_GCC}, 7.5),1)
ADDITIONAL_CXXFLAGS += -D_GLIBCXX_USE_C99 -D_GLIBCXX_USE_C99_MATH
endif
