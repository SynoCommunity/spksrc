PKG_NAME = diesel
PKG_VERS = 2.1.6
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/diesel-rs/diesel/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS += cross/mysql-connector-c

# powerpc archs (except qoriq) are not supported
UNSUPPORTED_ARCHS += $(OLD_PPC_ARCHS)

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
export "MYSQL_DB_SOCKET=/run/mysqld/mysqld10.sock"

# let ./configure find mysql_config (it is a script and works for cross compile)
ENV += "PATH=$(PATH):$(STAGING_INSTALL_PREFIX)/bin"
# to find dependencies of libmysqlclient (libz)
ENV += RUSTFLAGS="-Clink-arg=-Wl,--rpath,$(INSTALL_PREFIX)/lib -Clink-arg=-Wl,--rpath-link,$(STAGING_INSTALL_PREFIX)/lib"

include ../../mk/spksrc.cross-rust.mk
