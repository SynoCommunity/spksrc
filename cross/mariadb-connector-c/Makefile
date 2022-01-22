PKG_NAME = mariadb-connector-c
PKG_VERS = 3.2.5
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mariadb-corporation/mariadb-connector-c/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://mariadb.com/kb/en/mariadb-connector-c/
COMMENT  = MariaDB C Connector
LICENSE  = LGPL

include ../../mk/spksrc.cross-cmake.mk

# MySQL specific:
CMAKE_ARGS += -DWITH_UNIT_TESTS=OFF
CMAKE_ARGS += -DDEFAULT_CHARSET=utf8
CMAKE_ARGS += -DINSTALL_LIBDIR=lib

DEPENDS += cross/openssl
CMAKE_ARGS += -DWITH_SSL=ON
DEPENDS += cross/zlib
CMAKE_ARGS += -DWITH_EXTERNAL_ZLIB=ON
DEPENDS += cross/libiconv
CMAKE_ARGS += -DWITH_ICONV=ON
DEPENDS += cross/curl
CMAKE_ARGS += -DWITH_CURL=ON
