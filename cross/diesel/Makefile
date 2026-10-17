PKG_NAME = diesel
PKG_VERS = 2.3.9
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/diesel-rs/diesel/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS += cross/mariadb-connector-c

# Two blockers, both verified by building for the arch in question:
#   cross/mariadb-connector-c falls back to 3.3.11, which gcc 4.3.7 cannot build
#     plugins/pvio/pvio_socket.c:186: error: missing initializer (-Werror)
#   a transitive crate needs edition 2024, which cargo 1.82 -- the version every
#   rust overlay pins -- cannot parse
#     feature `edition2024` is required ... not stabilized in this version of Cargo
MIN_GCC_VERSION = 4.6
MIN_RUSTC_VERSION = 1.85

HOMEPAGE = https://diesel.rs/
COMMENT  = A safe, extensible ORM and Query Builder for Rust.
LICENSE  = MIT

# build the cli tool for mysql
RUST_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)/diesel_cli
CARGO_BUILD_ARGS += --no-default-features
CARGO_BUILD_ARGS += --features=mysql

# we support MariaDB 10 only
# we must define the mysql db socket, since the rust binaries (mysqlclient-sys)
# do not read settings from bin/mysql_conf
export MYSQL_DB_SOCKET=/run/mysqld/mysqld10.sock

# Point to MariaDB library and include directories
ENV += MYSQLCLIENT_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib
ENV += MYSQLCLIENT_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include/mariadb

# let ./configure find mysql_config (it is a script and works for cross compile)
ENV += "PATH=$(PATH):$(STAGING_INSTALL_PREFIX)/bin"

include ../../mk/spksrc.cross-rust.mk

# pass mysql client version (needed by mysqlclient-sys crate)
# Use same conditional as mariadb-connector-c to select correct version
ifeq ($(call version_ge, $(TC_GCC), 5),1)
ENV += MYSQLCLIENT_VERSION=$(shell sed -n 's/^PKG_VERS = //p' $(BASEDIR)/cross/mariadb-connector-c-latest/Makefile)
else
ENV += MYSQLCLIENT_VERSION=$(shell sed -n 's/^PKG_VERS = //p' $(BASEDIR)/cross/mariadb-connector-c-3.3.11/Makefile)
endif
