PKG_NAME = bitwarden_rs
PKG_VERS = 1.13.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/dani-garcia/bitwarden_rs/archive
PKG_DIST_FILE = $(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

RUST_FEATURES=mysql
RUST_TOOLCHAIN=nightly

DEPENDS = cross/openssl

CARGO_ENV=OPENSSL_DIR=$(STAGING_INSTALL_PREFIX)

# armv7 without hardfloat is not supported
UNSUPPORTED_ARCHS = hi3535
# powerpc archs (except qoriq) are not supported
UNSUPPORTED_ARCHS += powerpc ppc824x ppc853x ppc854x

include ../../mk/spksrc.cross-rust.mk


