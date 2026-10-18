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

# 4.1.3 needs C++17 -- cmake refuses gcc 4.9.3 outright ("requires the language
# dialect CXX17") -- and gcc 7.5 then dies inside it:
#   libtransmission/tr-popcount.h:62: internal compiler error: in reshape_init_r,
#   at cp/decl.c:6072     (constexpr auto PopcntLut = std::array<uint8_t, 256>{...})
#   bits/stl_construct.h:75: use of deleted function 'tr_variant::tr_variant(const tr_variant&)'
# So the floor is 8, not the "gcc >= 5.1" this file used to claim, and it refuses
# DSM 7.0 as well as comcerto2k.
MIN_GCC_VERSION = 8

CONFIGURE_ARGS = -DCMAKE_BUILD_TYPE=RelWithDebInfo
CONFIGURE_ARGS += -DBUILD_SHARED_LIBS=OFF
CONFIGURE_ARGS += -DENABLE_TESTS=OFF

include ../../mk/spksrc.cross-cmake.mk
