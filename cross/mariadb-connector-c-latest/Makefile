PKG_NAME = mariadb-connector-c
PKG_VERS = 3.4.7
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mariadb-corporation/mariadb-connector-c/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://mariadb.com/kb/en/mariadb-connector-c/
COMMENT  = MariaDB C Connector
LICENSE  = LGPL

REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = comcerto2k

CMAKE_DISABLE_EXE_LINKER_FLAGS = 1

# MySQL specific:
CMAKE_ARGS += -DWITH_UNIT_TESTS=OFF
CMAKE_ARGS += -DDEFAULT_CHARSET=utf8
CMAKE_ARGS += -DINSTALL_LIBDIR=lib

# Creates the following two synlinks:
#   - libmysqlclient.so -> libmariadb.so.3
#   - libmysqlclient_r.so -> libmariadb.so.3
# Which in turns conflict with mysql-connector-c
#   - DISABLE unsupported mysql-connector-c
CMAKE_ARGS += -DWITH_MYSQLCOMPAT=ON

# Does not handle pkgconfig well and fails to
# find openssl3 include and libraries using
# spksrc.python.mk thus using OPENSSL_STAGING_PREFIX
DEPENDS += cross/openssl3
CMAKE_ARGS += -DWITH_SSL=ON
ifneq ($(wildcard $(OPENSSL_STAGING_PREFIX)),)
CMAKE_ARGS += -DOPENSSL_CRYPTO_LIBRARY:FILEPATH=$(OPENSSL_STAGING_PREFIX)/lib/libcrypto.so
CMAKE_ARGS += -DOPENSSL_SSL_LIBRARY:FILEPATH=$(OPENSSL_STAGING_PREFIX)/lib/libssl.so
CMAKE_ARGS += -DOPENSSL_INCLUDE_DIR:PATH=$(OPENSSL_STAGING_PREFIX)/include
endif

DEPENDS += cross/zlib
CMAKE_ARGS += -DWITH_EXTERNAL_ZLIB=ON
DEPENDS += cross/libiconv
CMAKE_ARGS += -DWITH_ICONV=ON
DEPENDS += cross/curl
CMAKE_ARGS += -DWITH_CURL=ON

include ../../mk/spksrc.cross-cmake.mk
