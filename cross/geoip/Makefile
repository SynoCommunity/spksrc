PKG_NAME = GeoIP
PKG_VERS = 1.4.8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.maxmind.com/download/geoip/api/c
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

HOMEPAGE = http://dev.maxmind.com/geoip/
COMMENT  = The GeoIP product is available in a variety of downloadable databases. These databases use a custom binary format to maximize lookup speed. MaxMind also offers CSV versions of the same data. This is useful if you would like to import this data into a SQL RDBMS, for example.
LICENSE  = LGPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = 

include ../../mk/spksrc.cross-cc.mk
