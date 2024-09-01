PKG_NAME = mysql-connector-c
PKG_VERS = 6.1.11
PKG_EXT = tar.gz
DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-src
PKG_DIST_NAME = $(DIST_NAME).$(PKG_EXT)
PKG_DIST_SITE = https://cdn.mysql.com/archives/$(PKG_NAME)
PKG_DIR = $(DIST_NAME)

BUILD_DEPENDS = native/libmysqlclient

HOMEPAGE = https://downloads.mysql.com/archives/c-c
COMMENT  = MySQL C API (libmysqlclient) 
LICENSE  = GNU GPLv2

USE_NATIVE_CMAKE_LEGACY = 1
CMAKE_USE_NINJA = 1

POST_INSTALL_TARGET = mysql-connector-c_post_install

include ../../mk/spksrc.cross-cmake.mk

# give access to comp_err binary on host
ENV += PATH=$(WORK_DIR)/../../../native/libmysqlclient/work-native/install/usr/local/bin/:$(CMAKE_PATH):$$PATH

# custom mysql socket addr (default is /tmp/mysql.sock)
# on DSM 7 (only MariaDB 10 available)
# /run/mysqld/mysqld10.sock  (links to /run/mysqld/mysqld.sock)
# /run/mysqld/mysqld.sock
# on DSM 6 with mariadb 5 and 10
# /run/mysqld/mysqld.sock (MariaDB 5)
# /run/mysqld/mysqld10.sock (MariaDB 10)
ifeq ($(MYSQL_DB_SOCKET),)
# default mysql socket for DSM
MYSQL_DB_SOCKET = /run/mysqld/mysqld.sock
endif
CMAKE_ARGS += -DMYSQL_UNIX_ADDR=$(MYSQL_DB_SOCKET)

# Mandatory for build
CMAKE_ARGS += -DHAVE_LLVM_LIBCPP_EXITCODE=1 
CMAKE_ARGS += -DHAVE_CXX_FLOATING_POINT_OPTIMIZATION_PROBLEMS_EXITCODE=1
CMAKE_ARGS += -DHAVE_C_FLOATING_POINT_OPTIMIZATION_PROBLEMS_EXITCODE=1
CMAKE_ARGS += -DHAVE_C_FLOATING_POINT_OPTIMIZATION_PROBLEMS_EXITCODE__TRYRUN_OUTPUT=1
# MySQL specific:
CMAKE_ARGS += -DSTACK_DIRECTION=1
CMAKE_ARGS += -DWITH_UNIT_TESTS=OFF
CMAKE_ARGS += -DWITH_EMBEDDED_SERVER=FALSE
CMAKE_ARGS += -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci
# Fix full lib version:
CMAKE_ARGS += -DSHARED_LIB_PATCH_VERSION=0
# Fix for mariadb connector
CMAKE_ARGS += -DINSTALL_INCLUDEDIR=include/mysql

# WITH_SSL=[yes|bundled|system|<path/to/custom/installation>]
# Not compatible with OpenSSL 1.1
# Requires updating to mysql-connector-c++ version 8.x
#DEPENDS += cross/openssl
#CMAKE_ARGS += -DWITH_SSL=system
DEPENDS += cross/zlib
CMAKE_ARGS += -DWITH_ZLIB=system

# Use gcc builtin atomic functions for ppc architectures
ifneq ($(findstring $(ARCH),$(PPC_ARCHS)),)
CMAKE_ARGS += -DHAVE_GCC_ATOMIC_BUILTINS=1
endif

.PHONY: mysql-connector-c_post_install
mysql-connector-c_post_install:
	@$(MSG) Fix for mysql_config --libs 
	@$(RUN) sed 's|"$$libs -l "|"$$libs -lmysqlclient "|g' -i $(INSTALL_DIR)$(INSTALL_PREFIX)/bin/mysql_config
