PKG_NAME = mariadb-connector-c
# Version 3.3.11 is the last known version to work with aarch64-6.2.4
# Assembly error: Error: CFI instruction used without previous .cfi_startproc
PKG_VERS = 3.3.11
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mariadb-corporation/mariadb-connector-c/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://mariadb.com/kb/en/mariadb-connector-c/
COMMENT  = MariaDB C Connector
LICENSE  = LGPL

CMAKE_DISABLE_EXE_LINKER_FLAGS = 1

include ../../mk/spksrc.cross-cmake.mk

ifeq ($(call version_gt, $(TC_GCC), 4.9),1)
ADDITIONAL_CFLAGS += -Wno-error=maybe-uninitialized
# fails on evansport-6.2.4
ADDITIONAL_CFLAGS += -Wno-error=strict-aliasing
endif

ifeq ($(call version_lt, $(TC_GCC), 4.9),1)
ADDITIONAL_CFLAGS += -std=gnu99
# fails on 88f6281-6.2.4
ADDITIONAL_CFLAGS += -Wno-error=missing-field-initializers
ADDITIONAL_CFLAGS += -Wno-error=uninitialized
# fails on hi3535-6.2.4
ADDITIONAL_CFLAGS += -Wno-error=array-bounds
endif

# MySQL specific:
CMAKE_ARGS += -DWITH_UNIT_TESTS=OFF
CMAKE_ARGS += -DDEFAULT_CHARSET=utf8
CMAKE_ARGS += -DINSTALL_LIBDIR=lib

# Creates the following two synlinks:
#   - libmysqlclient.so -> libmariadb.so.3
#   - libmysqlclient_r.so -> libmariadb.so.3
# Which in turns conflict with mysql-connector-c
#CMAKE_ARGS += -DWITH_MYSQLCOMPAT=ON

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
