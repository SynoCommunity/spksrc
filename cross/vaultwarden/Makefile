PKG_NAME = vaultwarden
PKG_VERS = 1.25.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/dani-garcia/vaultwarden/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl cross/mysql-connector-c

HOMEPAGE = https://github.com/dani-garcia/vaultwarden/wiki
COMMENT = Alternative implementation of the Bitwarden server API written in Rust and compatible with upstream Bitwarden clients*, perfect for self-hosted deployment where running the official resource-heavy service might not be ideal.
LICENSE = GPLv3

CARGO_BUILD_ARGS = --features sqlite,mysql

ENV += OPENSSL_DIR=$(STAGING_INSTALL_PREFIX)
# prevent reading version from local git repository:
ENV += VW_VERSION="$(PKG_VERS) (SynoCommunity-$(ARCH))"

UNSUPPORTED_ARCHS = ARMVv5_ARCHS PCC_ARCHS

include ../../mk/spksrc.cross-rust.mk
