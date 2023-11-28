PKG_NAME = syncstorage-rs
PKG_VERS = 0.14.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mozilla-services/$(PKG_NAME)/archive/${PKG_VERS}
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# powerpc archs (except qoriq) are not supported
UNSUPPORTED_ARCHS += $(OLD_PPC_ARCHS)

HOMEPAGE = https://github.com/mozilla-services/syncstorage-rs/
COMMENT  = Mozilla Sync Storage built with Rust.
LICENSE  = https://github.com/mozilla-services/syncstorage-rs/blob/master/LICENSE

# Mandatory for rustc wheel building
ENV += PYO3_CROSS_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib/
ENV += PYO3_CROSS_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include/

# arguments to install the main server program
RUST_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)/syncserver
CARGO_BUILD_ARGS += --no-default-features
CARGO_BUILD_ARGS += --features=syncstorage-db/mysql
CARGO_BUILD_ARGS += --locked

include ../../mk/spksrc.cross-rust.mk
