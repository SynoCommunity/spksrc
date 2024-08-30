PKG_NAME = hiredis
PKG_VERS = 1.2.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/redis/hiredis/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = https://github.com/redis/hiredis
COMMENT  = Hiredis is a minimalistic C client library for the Redis database.
LICENSE  = BSD-3-Clause license

include ../../mk/spksrc.cross-cmake.mk
