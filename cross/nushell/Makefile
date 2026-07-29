PKG_NAME = nushell
# Do not go past 0.112.2 yet: nushell 0.113.0 pulls in the fff-search crate,
# whose AVX2 path is gated on any(x86_64, x86) but imports std::arch::x86_64,
# so it does not compile on 32-bit x86 (evansport). fff-search 0.9.7 narrows
# the gate to x86_64 and fixes it, but is only published as a prerelease.
PKG_VERS = 0.112.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/nushell/nushell/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# for nu_plugin_gstat and nu_plugin_query
DEPENDS = cross/openssl3

# openssl-sys refuses to fall back to pkg-config when host and target differ,
# so point it at the staging tree explicitly. Without this the plugins linking
# OpenSSL only build when the target happens to match the build host (x64).
ENV += OPENSSL_DIR=$(STAGING_INSTALL_PREFIX)

# some archs are supported under DSM 6, but x64 isn't (BoringSSL issue with ring crates).
# since nushell is a new package, we don't want to support DSM < 7 at all
REQUIRED_MIN_DSM = 7.0

HOMEPAGE = https://www.nushell.sh/
COMMENT  = A new type of shell.
LICENSE  = MIT

CARGO_BUILD_ARGS = --locked

NUSHELL_PLUGINS = inc polars gstat formats query

POST_INSTALL_TARGET = nushell_install_plugins

include ../../mk/spksrc.cross-rust.mk


# Plugins are installed from crates.io, so they must be pinned to $(PKG_VERS):
# nushell only loads plugins built against its own plugin protocol version.
# --locked is deliberately not used here: it would force the lock file each
# plugin was published with, which pins dependencies we cannot update.
.PHONY: nushell_install_plugins
nushell_install_plugins:
	@$(MSG) "Install the default plugins '$(NUSHELL_PLUGINS)' (v$(PKG_VERS))"
	@for plugin in $(NUSHELL_PLUGINS); do \
		$(MSG) "- Create plugin $${plugin}" ; \
		$(RUN) cargo +$(TC_RUSTUP_TOOLCHAIN) install --root $(STAGING_INSTALL_PREFIX) --version $(PKG_VERS) nu_plugin_$${plugin} --target $(RUST_TARGET) ; \
	done
