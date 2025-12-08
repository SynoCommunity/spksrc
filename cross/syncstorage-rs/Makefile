PKG_NAME = syncstorage-rs
PKG_VERS = 0.21.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mozilla-services/$(PKG_NAME)/archive/${PKG_VERS}
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# for openssl-sys
DEPENDS = cross/openssl3
# for mysqlclient-sys
DEPENDS += cross/mariadb-connector-c

# powerpc archs are not supported
UNSUPPORTED_ARCHS += $(PPC_ARCHS)

HOMEPAGE = https://github.com/mozilla-services/syncstorage-rs/
COMMENT  = Mozilla Sync Storage built with Rust.
LICENSE  = MPL 2.0

# arguments to install the main server program
RUST_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)/syncserver
CARGO_BUILD_ARGS += --no-default-features
CARGO_BUILD_ARGS += --features=syncstorage-db/mysql
CARGO_BUILD_ARGS += --locked

# we support MariaDB 10 only
# we must define the mysql db socket, since the rust binaries (mysqlclient-sys)
# do not read settings from bin/mysql_conf
export MYSQL_DB_SOCKET=/run/mysqld/mysqld10.sock

# mysqlclient-sys: to find libmysqlclient
ENV += MYSQLCLIENT_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib
# to find dependencies of libmysqlclient (libz)
ENV += RUSTFLAGS="-Clink-arg=-Wl,--rpath,$(INSTALL_PREFIX)/lib -Clink-arg=-Wl,--rpath-link,$(STAGING_INSTALL_PREFIX)/lib"

# pass mysql client version for non-x86 archs
ENV += MYSQLCLIENT_VERSION=$(lastword $(subst -, ,$(wildcard $(WORK_DIR)/mariadb-connector-c-[0-9]*)))

POST_INSTALL_TARGET = syncstorage-rs_post_install

include ../../mk/spksrc.cross-rust.mk

.PHONY: syncstorage-rs_post_install
syncstorage-rs_post_install:
	@$(MSG) Install Tools
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/tools
	@tar -cf - -C $(WORK_DIR)/$(PKG_DIR)/tools . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/tools
	@$(MSG) Install DB Migration scripts
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/syncstorage-mysql/migrations -d $(STAGING_INSTALL_PREFIX)/tokenserver-db/migrations
	@tar -cf - -C $(WORK_DIR)/$(PKG_DIR)/syncstorage-mysql/migrations . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/syncstorage-mysql/migrations
	@tar -cf - -C $(WORK_DIR)/$(PKG_DIR)/tokenserver-db/migrations . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/tokenserver-db/migrations
