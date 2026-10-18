PKG_NAME = transmission
PKG_VERS = 4.1.3
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/transmission/transmission/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/curl

HOMEPAGE = https://transmissionbt.com
COMMENT  = A Fast, Easy, and Free BitTorrent Client
LICENSE  = GPLv2/GPLv3

# 4.1.3 needs C++17, which cmake refuses below gcc 5, and gcc 7.5 then dies in it:
#   libtransmission/tr-popcount.h:62: internal compiler error: in reshape_init_r,
#   at cp/decl.c:6072
MIN_GCC_VERSION = 8

CONFIGURE_ARGS = -DCMAKE_BUILD_TYPE=RelWithDebInfo
CONFIGURE_ARGS += -DBUILD_SHARED_LIBS=OFF
CONFIGURE_ARGS += -DENABLE_TESTS=OFF

include ../../mk/spksrc.cross-cmake.mk
