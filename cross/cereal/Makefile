PKG_NAME = cereal
PKG_VERS = 1.3.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/USCiLab/cereal/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://uscilab.github.io/cereal/
COMMENT  = A C++11 library for serialization.
LICENSE  = 3-clause BSD

CMAKE_ARGS += -DSKIP_PORTABILITY_TEST=yes
CMAKE_ARGS += -DSKIP_PERFORMANCE_COMPARISON=yes
CMAKE_ARGS += -DWITH_WERROR=no

include ../../mk/spksrc.cross-cmake.mk

ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
# fix compilation with newer compilers
CMAKE_ARGS += -DCMAKE_CXX_FLAGS="-D_GLIBCXX_USE_C99 -D_GLIBCXX_USE_C99_MATH" 
endif
