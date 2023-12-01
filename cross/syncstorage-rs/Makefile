PKG_NAME = syncstorage-rs
PKG_VERS = 0.14.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mozilla-services/$(PKG_NAME)/archive/${PKG_VERS}
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# powerpc archs (except qoriq) are not supported
UNSUPPORTED_ARCHS += $(OLD_PPC_ARCHS)

HOMEPAGE = https://github.com/mozilla-services/syncstorage-rs/
COMMENT  = Mozilla Sync Storage built with Rust.
LICENSE  = https://github.com/mozilla-services/syncstorage-rs/blob/master/LICENSE

# arguments to install the main server program
RUST_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)/syncserver
CARGO_BUILD_ARGS += --no-default-features
CARGO_BUILD_ARGS += --features=syncstorage-db/mysql
CARGO_BUILD_ARGS += --locked

# only required for build in cross/syncstorage-rs folder (not when using prebuilt spk/python311)
#BUILD_DEPENDS = cross/python311
# for openssl-sys
DEPENDS = cross/openssl3
# for mysqlclient
DEPENDS += cross/mysql-connector-c

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

include ../../mk/spksrc.cross-rust.mk
