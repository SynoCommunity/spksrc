PKG_NAME = umurmur
PKG_VERS = 0.2.17
PKG_EXT = tar.gz
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/umurmur/umurmur/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libconfig cross/protobuf-c cross/openssl

HOMEPAGE = https://github.com/umurmur/umurmur
COMMENT  = Minimalistic Murmur (Mumble server)
LICENSE  = BSD 3-clause License

CMAKE_USE_DESTDIR = 0

include ../../mk/spksrc.cross-cmake.mk

# Mandatory umurmur cmake
# args for proper build
CMAKE_ARGS += -DSSL=openssl
CMAKE_ARGS += -DCMAKE_STAGING_PREFIX=$(STAGING_INSTALL_PREFIX)
