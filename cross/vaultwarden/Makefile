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

# mysqlclient-sys: to find libmysqlclient (mariadb-connector-c)
ENV += MYSQLCLIENT_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib
ENV += MYSQLCLIENT_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include/mariadb

# let ./configure find mysql_config (it is a script and works for cross compile)
ENV += "PATH=$(PATH):$(STAGING_INSTALL_PREFIX)/bin"

# libpq: to find PostgreSQL client library
ENV += PQ_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib

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

# pass mysql client version (needed by mysqlclient-sys crate)
# Use same conditional as mariadb-connector-c to select correct version
ifeq ($(call version_ge, $(TC_GCC), 5),1)
ENV += MYSQLCLIENT_VERSION=$(shell sed -n 's/^PKG_VERS = //p' $(BASEDIR)cross/mariadb-connector-c-latest/Makefile)
else
ENV += MYSQLCLIENT_VERSION=$(shell sed -n 's/^PKG_VERS = //p' $(BASEDIR)cross/mariadb-connector-c-3.3.11/Makefile)
endif
