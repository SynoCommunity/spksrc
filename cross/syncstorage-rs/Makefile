PKG_NAME = syncstorage-rs
PKG_VERS = 0.14.3
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
ENV += RUSTFLAGS="-Clink-arg=-Wl,--rpath-link,$(STAGING_INSTALL_PREFIX)/lib -Clink-arg=-Wl,--rpath-link,$(STAGING_INSTALL_PREFIX)/lib"

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
