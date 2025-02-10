PKG_NAME = syncstorage-rs
PKG_VERS = 0.18.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mozilla-services/$(PKG_NAME)/archive/${PKG_VERS}
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# only required for build in cross/syncstorage-rs folder (not when using prebuilt spk/python311)
#BUILD_DEPENDS = cross/python311
# for openssl-sys
DEPENDS = cross/openssl3
# for mysqlclient-sys
DEPENDS += cross/mysql-connector-c

# OLD_PPC_ARCHS are not supported for Rust builds
# Rust has support for qoriq, but the "ring" dependency has issue(s) with big-endian targets
# see: https://github.com/briansmith/ring/issues/1555 (and referenced issues)
# There is an update in https://github.com/briansmith/ring/pull/1677 for (64-bit) PPC
# this might fix ring for 32-bit PPC (qoriq) too.
# An update of ring (>= 0.17.0) is required, syncstorage-rs 0.14.3 has locked ring to 0.16.20.
# 
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

# To find libpython in prebuilt or local built python
ifneq ($(PYTHON_STAGING_PREFIX),)
# use prebuilt python
ENV += PYO3_CROSS_LIB_DIR=$(PYTHON_STAGING_PREFIX)/lib/
ENV += PYO3_CROSS_INCLUDE_DIR=$(PYTHON_STAGING_PREFIX)/include/
else
# use local python (together with "BUILD_DEPENDS = cross/python311" above)
ENV += PYO3_CROSS_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib/
ENV += PYO3_CROSS_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include/
endif

# mysqlclient-sys: to find libmysqlclient
ENV += MYSQLCLIENT_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib
# to find dependencies of libmysqlclient (libz)
ENV += RUSTFLAGS="-Clink-arg=-Wl,--rpath,$(INSTALL_PREFIX)/lib -Clink-arg=-Wl,--rpath-link,$(STAGING_INSTALL_PREFIX)/lib"

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
