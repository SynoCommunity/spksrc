PKG_NAME = GeoIP
PKG_VERS = 1.6.9
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/maxmind/geoip-api-c/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

HOMEPAGE = http://dev.maxmind.com/geoip/
COMMENT  = The GeoIP product is available in a variety of downloadable databases. These databases use a custom binary format to maximize lookup speed. MaxMind also offers CSV versions of the same data. This is useful if you would like to import this data into a SQL RDBMS, for example.
LICENSE  = LGPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes

include ../../mk/spksrc.cross-cc.mk
