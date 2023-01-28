PKG_NAME = vaultwarden
PKG_VERS = 1.25.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/dani-garcia/vaultwarden/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl cross/mysql-connector-c cross/libpq

# issue with dependent component "ring"
# https://github.com/briansmith/ring/issues/1424
UNSUPPORTED_ARCHS = $(PPC_ARCHS)
# issue with dependent component "governor"
# https://github.com/antifuchs/governor/issues/89
UNSUPPORTED_ARCHS += $(ARMv5_ARCHS)

HOMEPAGE = https://github.com/dani-garcia/vaultwarden/wiki
COMMENT = Alternative implementation of the Bitwarden server API written in Rust and compatible with upstream Bitwarden clients*, perfect for self-hosted deployment where running the official resource-heavy service might not be ideal.
LICENSE = GPLv3

CARGO_INSTALL_ARGS = --features sqlite,mysql,postgresql

ENV += OPENSSL_DIR=$(STAGING_INSTALL_PREFIX)
# prevent reading version from local git repository:
ENV += VW_VERSION="$(PKG_VERS) (SynoCommunity-$(ARCH))"

include ../../mk/spksrc.cross-rust.mk
