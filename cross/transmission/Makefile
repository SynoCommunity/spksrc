PKG_NAME = transmission
PKG_VERS = 4.0.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-with-submodules.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/SynoCommunity/spksrc/releases/download/transmission
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/curl

HOMEPAGE = https://transmissionbt.com
COMMENT  = A Fast, Easy, and Free BitTorrent Client
LICENSE  = GPLv2/GPLv3

# gcc >= 5.1 required
REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k

CMAKE_ARGS = -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
CMAKE_ARGS += -DENABLE_TESTS=OFF

include ../../mk/spksrc.cross-cmake.mk
