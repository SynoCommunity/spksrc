PKG_NAME = vaultwarden
PKG_VERS = 1.35.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/dani-garcia/vaultwarden/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl3 cross/mariadb-connector-c cross/libpq

# issue with dependent component "ring"
# https://github.com/briansmith/ring/issues/1424
UNSUPPORTED_ARCHS = $(PPC_ARCHS)

# issue with dependent component "governor"
# https://github.com/antifuchs/governor/issues/89
UNSUPPORTED_ARCHS += $(ARMv5_ARCHS)

# OLD_PPC_ARCHS, ARMv5_ARCHS and ARMv7L_ARCHS
# issue with dependent component "libmimalloc-sys"
# error: failed to run custom build command for `libmimalloc-sys v0.1.30`
# c_src/mimalloc/include/mimalloc-atomic.h:39:23: fatal error: stdatomic.h: No such file or directory
UNSUPPORTED_ARCHS += $(ARMv7L_ARCHS)

HOMEPAGE = https://github.com/dani-garcia/vaultwarden/wiki
COMMENT = Alternative implementation of the Bitwarden server API written in Rust and compatible with upstream Bitwarden clients*, perfect for self-hosted deployment where running the official resource-heavy service might not be ideal.
LICENSE = GPLv3

CARGO_INSTALL_ARGS = --features sqlite,mysql,postgresql

ENV += OPENSSL_DIR=$(STAGING_INSTALL_PREFIX)
# prevent reading version from local git repository:
ENV += VW_VERSION="$(PKG_VERS) (SynoCommunity-$(ARCH))"

include ../../mk/spksrc.common.mk

ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
# fix for build of "libmimalloc-sys v0.1.30"
ADDITIONAL_CFLAGS = -std=c99
else ifeq ($(findstring $(ARCH),comcerto2k),$(ARCH))
ADDITIONAL_CFLAGS = -std=c99
endif

include ../../mk/spksrc.cross-rust.mk
