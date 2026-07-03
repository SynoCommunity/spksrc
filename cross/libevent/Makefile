PKG_NAME = libevent
PKG_VERS = 2.1.12-stable
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libevent/libevent/releases/download/release-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl3

HOMEPAGE = https://libevent.org
COMMENT  = Event notification library.
LICENSE  = 3-clause BSD

CMAKE_ARGS += -DEVENT__DISABLE_DEBUG_MODE=ON
CMAKE_ARGS += -DEVENT__DISABLE_BENCHMARK=ON
CMAKE_ARGS += -DEVENT__DISABLE_TESTS=ON
CMAKE_ARGS += -DEVENT__DISABLE_REGRESS=ON
CMAKE_ARGS += -DEVENT__DISABLE_SAMPLES=ON

include ../../mk/spksrc.cross-cmake.mk
